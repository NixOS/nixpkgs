{
  backendStdenv,
  cccl,
  cuda_crt,
  cuda_cudart,
  cuda_cuobjdump,
  cuda_nvcc,
  cudaAtLeast,
  cudaOlder,
  flags,
  lib,
  libcurand,
  llvmPackages,
  python3,
  testers,
}:
# Tests for the nvcc and nvlink wrappers; see README.md.
let
  # nvlink records its command line from CUDA 12.8 for some architectures, including sm_100, and from CUDA 13 for all.
  # The tests link programs without running them, so they use one of those architectures.
  recordsCommandLine = cudaAtLeast "12.8";
  arch = if recordsCommandLine then "sm_100" else lib.head flags.realArches;

  cudadevrtDir = "${lib.getOutput "static" cuda_cudart}/lib";

  # Whether the nvcc wrapper passes --frandom-seed. nvcc has that option from CUDA 12.9.
  seeds = cudaAtLeast "12.9";

  helpers = ''
    # Prints the command line recorded in each note written by nvlink.
    nvlinkOptions() {
      cuobjdump -elf "$1" \
        | awk '/Tool Name:/ { nvlink = ($3 == "nvlink") } nvlink && /Arguments:/ { sub(/.*Arguments: /, ""); print; nvlink = 0 }'
    }

    # Fails if a note in the file refers to the Nix store (by the hash of a store path, as Nix finds references), or if
    # nvlink wrote no note where it should have.
    checkNotes() {
      if cuobjdump -elf "$1" | grep -E 'Tool [A-Za-z ]+: .*[0-9a-df-np-sv-z]{32}'; then
        nixErrorLog "a note in $1 refers to the Nix store"
        exit 1
      fi
      local options
      options="$(nvlinkOptions "$1")"
      if [[ -z $options ]] && ${lib.boolToString recordsCommandLine}; then
        nixErrorLog "found no note from nvlink in $1"
        exit 1
      fi
      nixLog "nvlink recorded in $1: $options"
    }

    # Runs a command which must fail with the wrapper's error, message, and remove the output, result.
    expectFailure() {
      local message="$1"
      shift
      if "$@" 2> stderr.txt; then
        nixErrorLog "expected $* to fail"
        exit 1
      fi
      cat stderr.txt
      grep -F "nvlink wrapper: error: $message" stderr.txt
      if [[ -e result ]]; then
        nixErrorLog "expected the output to be removed"
        exit 1
      fi
    }

    # For the tests which run a wrapper next to a stand-in for the tool it wraps (tests/fake-tool).
    status() { "$@" && echo 0 || echo $?; }
    signal() { python3 ${./tests/signal.py} "$@"; }
    expect() {
      if [[ $1 != "$2" ]]; then
        nixErrorLog "$3: expected $2, got $1"
        exit 1
      fi
    }
  '';

  mkTest =
    name: script:
    backendStdenv.mkDerivation {
      __structuredAttrs = true;
      strictDeps = true;

      name = "${cuda_nvcc.name}-${name}";

      inherit arch;

      nativeBuildInputs = [
        cuda_cuobjdump
        cuda_nvcc
      ];

      buildInputs = [ cuda_cudart ];

      dontUnpack = true;
      dontConfigure = true;

      buildPhase = ''
        runHook preBuild
        cp ${./tests/kernel.cu} kernel.cu
        cp ${./tests/caller.cu} caller.cu
        cp ${./tests/answer.cu} answer.cu
        cp ${./tests/templates.cu} templates.cu
        cp ${./gpu-check.cu} gpu-check.cu
      ''
      + helpers
      + script
      + ''
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        [[ ! -e result ]] || cp -v result "$out/"
        runHook postInstall
      '';

      # The directories nvlink records must not become runtime dependencies. (Nix doesn't find references in compressed
      # fatbins, e.g. with -Xfatbin -compress-all, so checkNotes is what checks those.)
      disallowedRequisites = [ cuda_nvcc ] ++ map (output: cuda_cudart.${output}) cuda_cudart.outputs;

      meta = {
        inherit (cuda_nvcc.meta) badPlatforms platforms teams;
      };
    };
in
{
  # nvcc writes the same objects and programs when it runs again.
  nvcc-reproducible = mkTest "nvcc-reproducible" ''
    # Runs a command twice and compares the two outputs.
    twice() {
      local output="$1"
      shift
      "$@" -o "$output"
      mv "$output" first
      "$@" -o "$output"
      if ! cmp first "$output"; then
        nixErrorLog "$* wrote a different $output the second time"
        exit 1
      fi
    }
    twice kernel.o nvcc -arch="$arch" -c kernel.cu
    twice debug.o nvcc -arch="$arch" -g -c kernel.cu
    twice relocatable.o nvcc -arch="$arch" -rdc=true -c caller.cu
    # CMake compiles sources that are not named *.cu in this way.
    cp kernel.cu kernel.cpp
    twice language.o nvcc -arch="$arch" -x cu -c kernel.cpp
    # Without -c, the objects are intermediate files as well.
    twice result nvcc -arch="$arch" kernel.cu
    # CMake can pass the arguments in an options file.
    echo "-arch=$arch -c kernel.cu" > compile.optf
    twice options.o nvcc -optf compile.optf
    ${lib.optionalString seeds ''twice templates.o nvcc -arch="$arch" -c templates.cu''}

    # Without --keep, nvcc names its intermediate files tmpxft_<pid>_...
    if grep --text --fixed-strings tmpxft ./*.o result; then
      nixErrorLog "an output contains the name of a temporary file"
      exit 1
    fi

    # nvcc without the wrapper must still write different objects. If it does not, the wrapper is no longer needed.
    for source in kernel.cu ${lib.optionalString seeds "templates.cu"}; do
      (exec -a nvcc ${cuda_nvcc}/bin/.nvcc-wrapped -arch="$arch" -c "$source" -o unwrapped-1.o)
      (exec -a nvcc ${cuda_nvcc}/bin/.nvcc-wrapped -arch="$arch" --keep --keep-dir "$(mktemp -d)" -c "$source" \
        -o unwrapped-2.o)
      (exec -a nvcc ${cuda_nvcc}/bin/.nvcc-wrapped -arch="$arch" --keep --keep-dir "$(mktemp -d)" -c "$source" \
        -o unwrapped-3.o)
      if cmp --silent unwrapped-1.o unwrapped-2.o; then
        nixErrorLog "expected nvcc to name the object of $source after a temporary file"
        exit 1
      fi
      if ${lib.boolToString seeds} && [[ $source == templates.cu ]] && cmp --silent unwrapped-2.o unwrapped-3.o; then
        nixErrorLog "expected nvcc to name the symbols of $source after its process ID"
        exit 1
      fi
    done

    # The wrapper removes the directory in which nvcc kept the intermediate files.
    if [[ -n $(find "$TMPDIR" -maxdepth 1 -name 'nvcc-keep-*') ]]; then
      nixErrorLog "the wrapper left a directory in $TMPDIR"
      exit 1
    fi
  '';

  # The cases in which the wrapper does not override the caller, with the real nvcc.
  nvcc-options = mkTest "nvcc-options" ''
    # Two sources with the same name cannot share a directory for their intermediate files. Without -c, their objects
    # are in that directory too.
    mkdir a b
    echo 'int a() { return 1; }' > a/same.cu
    echo 'int a(); int main() { return a(); }' > b/same.cu
    nvcc -arch="$arch" a/same.cu b/same.cu -o result

    # nvcc uses the directory that the caller passes, and the wrapper does not remove it. CMake depends on this when
    # it identifies nvcc.
    mkdir kept
    nvcc -arch="$arch" --keep --keep-dir kept -c kernel.cu -o kernel.o
    [[ -e kept/kernel.ptx ]]
    nvcc -arch="$arch" -rdc=true --keep -c caller.cu -o caller.o
    [[ -e caller.ptx ]]
    NVCC_APPEND_FLAGS="--keep --keep-dir=kept" nvcc -arch="$arch" -c answer.cu -o answer.o
    [[ -e kept/answer.ptx ]]
    rm kept/kernel.ptx
    echo "--keep --keep-dir kept" > keep.optf
    nvcc -arch="$arch" -optf keep.optf -c kernel.cu -o kernel.o
    [[ -e kept/kernel.ptx ]]
    ${lib.optionalString seeds ''
      # nvcc uses the seed that the caller passes.
      nvcc -arch="$arch" --frandom-seed=1 -c templates.cu -o seed-1.o
      nvcc -arch="$arch" --frandom-seed=2 -c templates.cu -o seed-2.o
      NVCC_PREPEND_FLAGS=--frandom-seed=1 nvcc -arch="$arch" -c templates.cu -o seed-3.o
      if cmp --silent seed-1.o seed-2.o || ! cmp seed-1.o seed-3.o; then
        nixErrorLog "expected the seed passed to nvcc to be used"
        exit 1
      fi
    ''}

    # The wrapper exits with the status of nvcc, and removes the directory when nvcc fails too.
    echo 'syntax error' > broken.cu
    expected=0
    (exec -a nvcc ${cuda_nvcc}/bin/.nvcc-wrapped -arch="$arch" -c broken.cu -o broken.o) || expected=$?
    status=0
    nvcc -arch="$arch" -c broken.cu -o broken.o || status=$?
    if [[ $expected == 0 || $status != "$expected" ]]; then
      nixErrorLog "expected nvcc to exit with its status ($expected), got $status"
      exit 1
    fi

    # A configure check can pass an output that is not in a writable directory.
    nvcc -arch="$arch" -c kernel.cu -o /dev/null

    nvcc --version
    nvcc -arch="$arch" -E kernel.cu > /dev/null

    if [[ -n $(find "$TMPDIR" -maxdepth 1 -name 'nvcc-keep-*') ]]; then
      nixErrorLog "the wrapper left a directory in $TMPDIR"
      exit 1
    fi
  '';

  # The installed nvcc wrapper with a stand-in for nvcc next to it: the options it adds, and how it runs nvcc.
  nvcc-wrapper =
    (mkTest "nvcc-wrapper" ''
      cp ${cuda_nvcc}/bin/nvcc nvcc
      cp ${./tests/fake-tool} .nvcc-wrapped
      chmod +w nvcc
      chmod +x .nvcc-wrapped
      patchShebangs .nvcc-wrapped
      mkdir alone
      cp nvcc alone/nvcc
      export FAKE_LOG=$PWD/log
      touch source.cu
      mkdir a b
      touch a/same.cu b/same.cu

      # Prints the arguments that nvcc received.
      arguments() { sed '/^FAKE_ENV=/,$d' "$FAKE_LOG" | tr '\n' ' '; }
      # Runs the wrapper and prints the arguments that nvcc received.
      received() {
        FAKE=exit FAKE_STATUS=0 ./nvcc "$@"
        arguments
      }
      leftover() { find "$TMPDIR" -maxdepth 1 -name 'nvcc-keep-*' | wc -l; }

      # The wrapper adds its options before those of the caller. The seed and the directory have the same hash, which
      # depends on the arguments and on the working directory only.
      FAKE=exit FAKE_STATUS=0 ./nvcc -c source.cu -o source.o
      keepDir="$(sed -n 's/^--keep-dir=//p' log)"
      id="''${keepDir##*-}"
      [[ $keepDir == "$TMPDIR"/nvcc-keep-* && $id =~ ^[0-9a-f]{16}$ ]]
      seed=${lib.optionalString seeds ''"--frandom-seed=$id "''}
      keep="--keep --keep-dir=$keepDir "
      expect "$(arguments)" "$seed$keep-c source.cu -o source.o " "the arguments for a source file"
      expect "$(received -c source.cu -o source.o)" "$seed$keep-c source.cu -o source.o " "the arguments the second time"
      if [[ $(received -c source.cu -o other.o) == *"$id"* ]] ||
        [[ $(cd a && FAKE=exit FAKE_STATUS=0 ../nvcc -c ../source.cu -o source.o && arguments) == *"$id"* ]]; then
        nixErrorLog "expected another hash for other arguments and for another directory"
        exit 1
      fi
      # Without a source file, the wrapper adds nothing.
      expect "$(received source.o -o program)" "source.o -o program " "the arguments for a link"
      expect "$(received --version)" "--version " "the arguments without a file"

      # The caller's options are kept, whether they are arguments, in an options file, or in the environment.
      for option in --keep -keep --save-temps --keep-dir=kept -keep-dir=kept --objdir-as-tempdir; do
        expect "$(received "$option" -c source.cu | sed 's/^--frandom-seed=[^ ]* //')" "$option -c source.cu " \
          "the arguments with $option"
      done
      for option in --frandom-seed=1 "-frandom-seed 1"; do
        # shellcheck disable=SC2086
        expect "$(received $option -c source.cu | sed 's/^--keep --keep-dir=[^ ]* //')" "$option -c source.cu " \
          "the arguments with $option"
      done
      echo '-c "source.cu"' > source.optf
      echo '-optf source.optf --keep' > nested.optf
      [[ $(received -optf source.optf) == *"--keep --keep-dir="*"-optf source.optf " ]]
      [[ $(received --options-file=empty.optf,,source.optf) != *"--keep "* ]]
      expect "$(received -optf nested.optf | grep -c -e '--keep')" 0 "the directories added with --keep in an options file"
      expect "$(NVCC_APPEND_FLAGS="-O2 --keep-dir=kept" received -c source.cu | grep -c -e '--keep')" 0 \
        "the directories added with --keep-dir in NVCC_APPEND_FLAGS"
      expect "$(NVCC_PREPEND_FLAGS="--frandom-seed=1" received -c source.cu | grep -c -e '--frandom-seed')" 0 \
        "the seeds added with --frandom-seed in NVCC_PREPEND_FLAGS"
      # Two source files with the same name would overwrite each other's intermediate files.
      expect "$(received a/same.cu b/same.cu | grep -c -e '--keep')" 0 "the directories added for sources with the same name"
      # The wrapper leaves the arguments as they are when it can't read them; nvcc reports the error.
      echo '-c "source.cu' > unterminated.optf
      echo '-optf self.optf' > self.optf
      expect "$(received -optf unterminated.optf -c source.cu)" "-optf unterminated.optf -c source.cu " \
        "the arguments with an options file which ends in a quotation"
      expect "$(received -optf self.optf -c source.cu)" "-optf self.optf -c source.cu " \
        "the arguments with an options file which includes itself"
      expect "$(received -c source.cu -optf)" "-c source.cu -optf " "the arguments with -optf missing its value"
      # The wrapper doesn't read an options file which is a pipe, as nvcc would then find it empty.
      mkfifo pipe.optf
      echo '-c source.cu' > pipe.optf &
      expect "$(received -optf pipe.optf)" "-optf pipe.optf " "the arguments with an options file which is a pipe"
      expect "$(timeout 10 cat pipe.optf)" "-c source.cu" "the contents of the pipe after the wrapper ran"
      wait
      rm pipe.optf
      # The wrapper doesn't use a directory which isn't its own.
      ln -s "$PWD/a" "$keepDir"
      expect "$(received -c source.cu -o source.o | grep -c -e '--keep')" 0 "the directories added when it is a link"
      rm "$keepDir"

      # The directory exists while nvcc runs, only for the user, and is removed afterwards.
      rm -f log*
      FAKE="wait" ./nvcc -c source.cu -o source.o &
      until [[ -e log.ready ]]; do sleep 0.05; done
      expect "$(stat -c %a "$keepDir")" 700 "the mode of the directory"
      wait
      expect "$(leftover)" 0 "the directories left"

      # Exit statuses, arguments, and the environment are passed through, and the directory is removed.
      expect "$(FAKE=exit FAKE_STATUS=3 status ./nvcc -c source.cu)" 3 "nvcc's exit status"
      expect "$(FAKE=exit FAKE_STATUS=3 status ./nvcc --version)" 3 "nvcc's exit status without a source file"
      FAKE=exit FAKE_STATUS=0 FAKE_ENV="a b" ./nvcc "x y" "" -c source.cu --keep
      # Outside the foreground of a terminal, as here, nvcc runs in a process group of its own when the wrapper waits
      # for it.
      expect "$(sed -n '/^x y$/,$p' log | grep -v -e '^pid=' -e '^group=')" $'x y\n\n-c\nsource.cu\n--keep\nFAKE_ENV=a b' \
        "nvcc's arguments and environment"
      FAKE=exit FAKE_STATUS=0 ./nvcc -c source.cu
      expect "$(sed -n 's/^group=//p' log)" own "nvcc's process group"
      expect "$(status ./alone/nvcc -c source.cu)" 127 "the exit status without .nvcc-wrapped next to the wrapper"
      expect "$(status ./alone/nvcc --version)" 127 "the exit status without .nvcc-wrapped and without a source file"
      # The wrapper finds nvcc next to itself rather than to the link it was run through.
      mkdir linked
      ln -s ../nvcc linked/nvcc
      expect "$(FAKE=exit FAKE_STATUS=4 status ./linked/nvcc -c source.cu)" 4 "nvcc's exit status through a symbolic link"
      expect "$(leftover)" 0 "the directories left"

      # If nvcc is killed by a signal, so is the wrapper, after it removed the directory.
      expect "$(FAKE=kill FAKE_SIGNAL=TERM signal none - ./nvcc -c source.cu)" -15 "how the wrapper exits when nvcc is killed"
      expect "$(leftover)" 0 "the directories left"

      # Signals sent to the wrapper, or to its process group, are forwarded to nvcc once, and the wrapper removes the
      # directory when nvcc exits.
      for sig in INT TERM group:TERM; do
        rm -f log*
        expect "$(FAKE="wait" signal "$sig" log.ready ./nvcc -c source.cu)" 0 "the exit status after $sig"
        expect "$(grep -c "received ''${sig#group:}" log)" 1 "$sig received by nvcc"
        expect "$(leftover)" 0 "the directories left"
      done
      rm -f log*
      expect "$(FAKE="wait" signal ctrl-c log.ready ./nvcc -c source.cu)" 0 "the exit status after Ctrl-C"
      expect "$(grep -c "received INT" log)" 1 "SIGINT received by nvcc after Ctrl-C"
      expect "$(sed -n 's/^group=//p' log)" shared "nvcc's process group in the foreground of a terminal"

      # nvcc doesn't outlive the wrapper. The directory is left, and the next run uses and removes it.
      rm -f log*
      expect "$(FAKE="sleep" signal KILL log.ready ./nvcc -c source.cu -o source.o)" -9 "how the wrapper exits when killed"
      for _ in $(seq 50); do
        kill -0 "$(sed -n 's/^pid=//p' log)" 2> /dev/null || break
        sleep 0.1
      done
      if kill -0 "$(sed -n 's/^pid=//p' log)" 2> /dev/null; then
        nixErrorLog "nvcc outlived the wrapper"
        exit 1
      fi
      expect "$(leftover)" 1 "the directories left by a wrapper which was killed"
      expect "$(received -c source.cu -o source.o)" "$seed$keep-c source.cu -o source.o " "the arguments with the directory left"
      expect "$(leftover)" 0 "the directories left"
    '').overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ python3 ];
      });

  # nvcc runs nvlink for a whole-program link, even without -rdc.
  nvcc-whole-program = mkTest "nvcc-whole-program" ''
    nvcc -arch="$arch" kernel.cu -o result
    checkNotes result
  '';

  # The -L passed by the build is removed along with nvcc's own.
  nvcc-library-dir = mkTest "nvcc-library-dir" ''
    nvcc -arch="$arch" -rdc=true caller.cu answer.cu -L${cudadevrtDir} -o result
    checkNotes result
  '';

  # Nix doesn't find references in a compressed fatbin, so disallowedRequisites can't catch them there; checkNotes reads
  # the notes through cuobjdump, which decompresses them.
  nvcc-compressed = mkTest "nvcc-compressed" ''
    nvcc -arch="$arch" -rdc=true -Xfatbin -compress-all caller.cu answer.cu -L${cudadevrtDir} -o result
    checkNotes result
    options="$(nvlinkOptions result)"
    if [[ -n $options ]] && grep -a -q -F -- "$options" result; then
      nixErrorLog "expected the note in result to be compressed"
      exit 1
    fi
  '';

  # The host linker copies the fatbin, and so the note, as-is.
  nvcc-static-executable =
    (mkTest "nvcc-static-executable" ''
      nvcc -arch="$arch" -rdc=true -Xcompiler -static caller.cu answer.cu -L${cudadevrtDir} -o result
      if readelf --program-headers result | grep -E 'INTERP|DYNAMIC'; then
        nixErrorLog "expected result to be a static executable"
        exit 1
      fi
      # cuobjdump doesn't find the device code in a static executable.
      objcopy --dump-section .nv_fatbin=fatbin result
      checkNotes fatbin
    '').overrideAttrs
      (prevAttrs: {
        buildInputs = prevAttrs.buildInputs ++ [ (lib.getOutput "static" backendStdenv.cc.libc) ];
      });

  # A device-link object in a static library, as from CMake's CUDA_RESOLVE_DEVICE_SYMBOLS.
  nvcc-device-link-object = mkTest "nvcc-device-link-object" ''
    nvcc -arch="$arch" -rdc=true -c caller.cu answer.cu
    nvcc -arch="$arch" -dlink caller.o answer.o -L${cudadevrtDir} -o dlink.o
    ar rcs result caller.o answer.o dlink.o
    checkNotes result
  '';

  # nvcc passes long command lines to nvlink in an options file, which names the output (CUDA 12.8 and newer; CUDA 12.6
  # passes them directly).
  nvcc-options-file = mkTest "nvcc-options-file" ''
    libdirs=()
    for i in $(seq 1000); do
      libdirs+=("-L$NIX_BUILD_TOP/a/directory/with/a/long/enough/name/to/make/the/command/line/long/$i")
    done
    nvcc -arch="$arch" -rdc=true caller.cu answer.cu -L${cudadevrtDir} "''${libdirs[@]}" -o result --dryrun 2> dryrun.txt
    ${lib.optionalString recordsCommandLine "grep -F 'nvlink -optf' dryrun.txt"}
    nvcc -arch="$arch" -rdc=true caller.cu answer.cu -L${cudadevrtDir} "''${libdirs[@]}" -o result
    checkNotes result
  '';

  # The wrapper doesn't depend on setup hooks, as with nix develop or a build system outside stdenv.
  nvcc-empty-environment = mkTest "nvcc-empty-environment" ''
    env -i TMPDIR="$TMPDIR" ${lib.getExe cuda_nvcc} -arch="$arch" -rdc=true caller.cu answer.cu \
      ${
        lib.concatMapStringsSep " " (p: "-I${lib.getInclude p}/include") (
          [ cuda_cudart ] ++ lib.optionals (cudaAtLeast "13.0") [ cuda_crt ]
        )
      } \
      -L${cudadevrtDir} -o result
    checkNotes result
  '';

  # nvlink called directly, with each spelling of the output and options files.
  nvlink-output = mkTest "nvlink-output" ''
    nvcc -arch="$arch" -rdc=true -c caller.cu answer.cu
    link() {
      nvlink --arch="$arch" caller.o answer.o -L ${cudadevrtDir} "''${@:2}"
      checkNotes "$1"
    }
    link a -o a
    link b -o=b
    link c --output-file c
    link d --output-file=d
    link e -o ignored -o e

    # Double quotes group, a backslash escapes (dropping escaped double quotes), and options files may include others.
    printf '%s\n' '-o "f g"' > quoted.optf
    printf '%s\n' '-o h\ i' > escaped.optf
    printf '%s\n' '-o "j\"k"' > escaped-quote.optf
    printf '%s\n' '-L ${cudadevrtDir}' '-optf quoted.optf' > nested.optf
    link "f g" -optf quoted.optf
    link "h i" -optf escaped.optf
    link jk -optf escaped-quote.optf
    link "f g" --options-file=nested.optf
    link "h i" -optf nested.optf,,escaped.optf

    # Only the hashes change, to e's (octal 145): the output is otherwise the same as nvlink's.
    (exec -a nvlink ${cuda_nvcc}/bin/.nvlink-wrapped --arch="$arch" caller.o answer.o -L ${cudadevrtDir} -o unwrapped)
    [[ $(stat -c %s a) == $(stat -c %s unwrapped) ]]
    cmp -l a unwrapped > differences || true
    awk '$2 != 145 { print "unexpected difference: " $0; exit 1 }' differences
    ${lib.optionalString recordsCommandLine "[[ -s differences ]]"}

    # A host linker script is written as-is.
    nvlink -ghls lcs-abs -o wrapped.ld
    ${cuda_nvcc}/bin/.nvlink-wrapped -ghls lcs-abs -o unwrapped.ld
    cmp wrapped.ld unwrapped.ld

    nvlink --version
  '';

  # CUDA 13's nvlink keeps the notes of the cubins it links, including those of cubins linked without the wrapper, which
  # the wrapper scrubs too.
  nvlink-input-notes = mkTest "nvlink-input-notes" ''
    nvcc -arch="$arch" -rdc=true -c caller.cu answer.cu
    # NOTE: nvlink only links inputs named *.cubin as cubins, and before CUDA 13, a relocatable link of relocatable
    # device code requires libcudadevrt.
    (exec -a nvlink ${cuda_nvcc}/bin/.nvlink-wrapped --arch="$arch" -r caller.o answer.o -L ${cudadevrtDir} -lcudadevrt \
      -o input.cubin)
    nvlink --arch="$arch" input.cubin -L ${cudadevrtDir} -o result
    checkNotes result
    if ${lib.boolToString (cudaAtLeast "13.0")} && (( $(nvlinkOptions result | wc -l) < 2 )); then
      nixErrorLog "expected nvlink to keep the note of its input"
      exit 1
    fi
  '';

  # The wrapper reads the output back, so an output which isn't a regular file fails before nvlink runs.
  nvlink-stream-output = mkTest "nvlink-stream-output" ''
    nvcc -arch="$arch" -rdc=true -c caller.cu answer.cu
    # The wrapper would block reading back the output from the pipe.
    expectFailure "/dev/stdout is not a regular file" \
      timeout -s KILL 60 bash -c "nvlink --arch=$arch caller.o answer.o -o /dev/stdout | cat > streamed; exit \''${PIPESTATUS[0]}"
    [[ ! -s streamed ]]
  '';

  # nvlink's errors and exit status are passed through.
  nvlink-error = testers.testBuildFailure' {
    drv = mkTest "nvlink-error" ''
      nvcc -arch="$arch" -rdc=true -c caller.cu
      # Without answer.o.
      nvlink --arch="$arch" caller.o -o result
    '';
    expectedBuilderExitCode = 255;
    expectedBuilderLogEntries = [ "Undefined reference to '_Z6answerv'" ];
  };

  # The installed wrapper's handling of nvlink as a process and of its output, with a stand-in for nvlink next to it.
  wrapper =
    (mkTest "wrapper" ''
      cp ${cuda_nvcc}/bin/nvlink nvlink
      cp ${./tests/fake-tool} .nvlink-wrapped
      chmod +w nvlink
      chmod +x .nvlink-wrapped
      patchShebangs .nvlink-wrapped
      mkdir alone
      cp nvlink alone/nvlink
      export FAKE_LOG=$PWD/log

      # Exit statuses, arguments, and the environment are passed through.
      expect "$(FAKE=exit FAKE_STATUS=3 status ./nvlink)" 3 "nvlink's exit status"
      FAKE=exit FAKE_STATUS=0 FAKE_ENV="a b" ./nvlink "x y" ""
      # Outside the foreground of a terminal, as here, nvlink runs in a process group of its own.
      expect "$(cat log)" $'x y\n\nFAKE_ENV=a b\npid='"$(sed -n 's/^pid=//p' log)"$'\ngroup=own' \
        "nvlink's arguments, environment, and process group"
      expect "$(status ./alone/nvlink)" 127 "the exit status without .nvlink-wrapped next to the wrapper"
      # The wrapper finds nvlink next to itself rather than to the link it was run through.
      mkdir linked
      ln -s ../nvlink linked/nvlink
      expect "$(FAKE=exit FAKE_STATUS=4 status ./linked/nvlink)" 4 "nvlink's exit status through a symbolic link"
      # The wrapper forwards SIGTERM rather than exiting, so the timeout kills it.
      ignoringSigchld='import os, signal, sys; signal.signal(signal.SIGCHLD, signal.SIG_IGN); os.execv(sys.argv[1], sys.argv[1:])'
      expect "$(FAKE=exit FAKE_STATUS=3 status timeout -s KILL 60 python3 -c "$ignoringSigchld" ./nvlink)" 3 \
        "nvlink's exit status with SIGCHLD ignored, which is inherited"

      # If nvlink is killed by a signal, so is the wrapper.
      expect "$(FAKE=kill FAKE_SIGNAL=TERM signal none - ./nvlink)" -15 "how the wrapper exits when nvlink is killed"

      # Signals sent to the wrapper, or to its process group, are forwarded to nvlink once.
      for sig in HUP INT QUIT TERM USR1 USR2 group:TERM group:USR1; do
        rm -f log*
        expect "$(FAKE="wait" signal "$sig" log.ready ./nvlink)" 0 "the exit status after $sig"
        expect "$(grep -c "received ''${sig#group:}" log)" 1 "$sig received by nvlink"
      done
      # In the foreground of a terminal, nvlink shares the wrapper's process group, so signals from the terminal reach
      # it directly, and aren't forwarded.
      rm -f log*
      expect "$(FAKE="wait" signal ctrl-c log.ready ./nvlink)" 0 "the exit status after Ctrl-C"
      expect "$(grep -c "received INT" log)" 1 "SIGINT received by nvlink after Ctrl-C"
      expect "$(sed -n 's/^group=//p' log)" shared "nvlink's process group in the foreground of a terminal"
      rm -f log*
      expect "$(FAKE=detached signal ctrl-c log.ready ./nvlink)" 0 "the exit status after Ctrl-C"
      expect "$(grep -c "received INT" log || true)" 0 "SIGINT forwarded to nvlink after Ctrl-C"

      # nvlink doesn't outlive the wrapper.
      rm -f log*
      expect "$(FAKE="sleep" signal KILL log.ready ./nvlink)" -9 "how the wrapper exits when killed"
      for _ in $(seq 50); do
        kill -0 "$(sed -n 's/^pid=//p' log)" 2> /dev/null || break
        sleep 0.1
      done
      if kill -0 "$(sed -n 's/^pid=//p' log)" 2> /dev/null; then
        nixErrorLog "nvlink outlived the wrapper"
        exit 1
      fi

      # Hashes of store paths are blanked in .note.nv.tkinfo sections, and only there.
      hash=0123456789abcdfghijklmnpqrsvwxyz
      printf 'nvlink\0-L ${builtins.storeDir}/%s-x/lib\0' "$hash" > note
      echo 'int x;' | "$CC" -c -x c - -o empty.o
      objcopy --add-section .note.nv.tkinfo=note --add-section .other=note empty.o note.o
      FAKE=write FAKE_CONTENTS=note.o ./nvlink -o scrubbed.o
      objcopy --dump-section .note.nv.tkinfo=scrubbed --dump-section .other=other scrubbed.o
      sed "s/$hash/$(printf 'e%.0s' {1..32})/" note > expected
      cmp scrubbed expected
      cmp other note
      # With many sections, the number of sections and the index of the section names are in the first section header.
      python3 -c '
      import struct, sys
      elf = bytearray(open(sys.argv[1], "rb").read())
      (shoff,) = struct.unpack_from("<Q", elf, 0x28)
      shnum, shstrndx = struct.unpack_from("<HH", elf, 0x3C)
      struct.pack_into("<HH", elf, 0x3C, 0, 0xFFFF)  # e_shnum, e_shstrndx (SHN_XINDEX)
      struct.pack_into("<Q", elf, shoff + 0x20, shnum)  # sh_size
      struct.pack_into("<I", elf, shoff + 0x28, shstrndx)  # sh_link
      open(sys.argv[2], "wb").write(elf)
      ' note.o extended.o
      readelf --file-header extended.o | grep -F 'Number of section headers:         0 ('
      FAKE=write FAKE_CONTENTS=extended.o ./nvlink -o scrubbed-extended.o
      expect "$(grep -a -o -F "$hash" scrubbed-extended.o | wc -l)" 1 "hashes left in a file with many sections"
      # The output is left as-is if nvlink fails.
      expect "$(FAKE=write FAKE_CONTENTS=note.o FAKE_STATUS=1 status ./nvlink -o failed.o)" 1 "nvlink's exit status"
      cmp failed.o note.o

      # Anything else the wrapper doesn't expect fails the link, before nvlink runs where possible.
      printf 'INPUT(${builtins.storeDir}/%s-x)\n' "$hash" > text
      FAKE=write FAKE_CONTENTS=text expectFailure "the output isn't an ELF file, but refers to the Nix store" \
        ./nvlink -o result
      printf '\x7fELF' > truncated
      FAKE=write FAKE_CONTENTS=truncated expectFailure "the output is a malformed ELF file" ./nvlink -o result
      { printf '\x7fELF\x01\x01'; head -c 58 /dev/zero; } > elf32
      FAKE=write FAKE_CONTENTS=elf32 expectFailure "the output isn't a 64-bit little-endian ELF file" ./nvlink -o result
      FAKE=exit FAKE_STATUS=0 expectFailure "/dev/null is not a regular file" ./nvlink -o /dev/null
      echo kept > kept
      FAKE=exit FAKE_STATUS=0 expectFailure "nvlink didn't write kept" ./nvlink -o kept
      expect "$(cat kept)" kept "an output nvlink didn't write"
      rm log
      FAKE=exit FAKE_STATUS=0 expectFailure "-o is missing its value" ./nvlink -o
      printf '%s' '-o "unterminated' > unterminated.optf
      FAKE=exit FAKE_STATUS=0 expectFailure "an options file ends in a backslash or a quotation" \
        ./nvlink -optf unterminated.optf
      printf '%s' '-optf self.optf' > self.optf
      FAKE=exit FAKE_STATUS=0 expectFailure "options files are nested too deeply" ./nvlink -optf self.optf
      FAKE=exit FAKE_STATUS=0 expectFailure "options file /dev/fd/" ./nvlink -optf <(echo -o result)
      FAKE=exit FAKE_STATUS=0 expectFailure "options file missing.optf is missing or not a regular file" \
        ./nvlink -optf missing.optf
      if [[ -e log ]]; then
        nixErrorLog "expected nvlink not to run"
        exit 1
      fi
    '').overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ python3 ];
      });
}
// lib.optionalAttrs recordsCommandLine {
  # Link-time optimization also records -nvvmpath, which is in cuda_nvcc.
  # NOTE: With caller.cu and answer.cu, only ptxas records its command line.
  nvcc-lto = mkTest "nvcc-lto" ''
    nvcc -arch="$arch" -rdc=true -dlto gpu-check.cu -L${cudadevrtDir} -o result
    checkNotes result
    [[ $(nvlinkOptions result) == *-dlto* ]]
  '';
}
//
  lib.optionalAttrs (cudaAtLeast "12.8" && cudaOlder "13.0" && !backendStdenv.hostPlatform.isx86_64)
    {
      # Clang links relocatable device code by running nvlink from its CUDA path, through clang-nvlink-wrapper, which
      # also passes Clang's own library directory.
      # NOTE: Clang 21 fails to parse CUDA 13's headers. On x86_64, the Clang wrapper passes -mtls-dialect=gnu2, which
      # Clang rejects for the device code.
      clang-gpu-rdc =
        let
          clang = llvmPackages.clang;
        in
        (mkTest "clang-gpu-rdc" ''
          # A CUDA installation laid out as Clang expects, linking to the wrapper as cudatoolkit does.
          toolkit=$PWD/toolkit
          mkdir -p "$toolkit/bin" "$toolkit/include"
          ln -s ${cuda_nvcc}/bin/{*,.nvlink-wrapped} "$toolkit/bin/"
          ln -s ${cuda_nvcc}/nvvm "$toolkit/nvvm"
          ln -s ${lib.getLib cuda_cudart}/lib "$toolkit/lib64"
          for dir in ${
            lib.concatMapStringsSep " " (p: "${lib.getInclude p}/include") [
              cccl
              cuda_cudart
              cuda_nvcc
              libcurand
            ]
          }; do
            ln -sf "$dir"/* "$toolkit/include/"
          done
          ${lib.getExe' clang "clang++"} -x cuda --cuda-path="$toolkit" --offload-arch="$arch" --offload-new-driver \
            -fgpu-rdc -Wno-unknown-cuda-version caller.cu answer.cu \
            -L${cudadevrtDir} -lcudart_static -ldl -lrt -lpthread \
            -o result
          checkNotes result
        '').overrideAttrs
          (prevAttrs: {
            # Clang applies them to the device code too, for which some (e.g. zerocallusedregs) are unsupported.
            hardeningDisable = [ "all" ];
            disallowedRequisites = prevAttrs.disallowedRequisites ++ [ clang.cc ];
          });
    }
