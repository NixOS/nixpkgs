{ python,
  fetchFromGitHub,
  clangStdenv,
  libffi,
  git,
  cmake,
  zlib,
  fetchgit,
  makeWrapper,
  runCommand,
  llvmPackages_5,
  gcc-unwrapped,
  glibc
}:

let
  # Make sure to use the stdenv that uses libc++ (the LLVM C++ standard library)
  # and not libstdc++ (the GNU one)
  # envToUse = llvmPackages_5.libcxxStdenv;
  envToUse = clangStdenv;

  # For using cling as a library (i.e. with xeus-cling)
  clingUnwrapped = envToUse.mkDerivation rec {
    pname = "cling";
    version = "0.7";

    src = fetchgit {
      url = "http://root.cern.ch/git/clang.git";

      # This commit has the tag cling-0.7 so we use it, even though cpt.py
      # tries to use refs/tags/cling-patches-rrelease_50
      rev = "354b25b5d915ff3b1946479ad07f3f2768ea1621";
      branchName = "cling-patches";

      sha256 = "181xfci1r9bs8r9grj9wbgi95sy85dj2nc6ggw9yjlhx94d0412y";
      leaveDotGit = true;
      deepClone = true;
    };

    clingSrc = fetchgit {
      url = "https://github.com/root-project/cling.git";
      rev = "70163975eee5a76b45a1ca4016bfafebc9b57e07";
      sha256 = "1zwnpxbqk6c0694sdmcxymivnpfc7hl2by6411n6vjxinavlpqz4";
    };

    preConfigure = ''
      echo "add_llvm_external_project(cling)" >> tools/CMakeLists.txt
      cp -r $clingSrc ./tools/cling
      chmod -R a+w ./tools/cling
    '';

    nativeBuildInputs = [python git cmake makeWrapper];
    buildInputs = [libffi llvmPackages_5.llvm zlib];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DLLVM_TARGETS_TO_BUILD=host;NVPTX"
      "-DLLVM_ENABLE_RTTI=ON"

      # Setting -DCLING_INCLUDE_TESTS=ON causes the cling/tools targets to be built;
      # see cling/tools/CMakeLists.txt
      "-DCLING_INCLUDE_TESTS=ON"
    ];
  };

  # The flags passed to the wrapped cling should
  # a) prevent it from searching for system include files and libs, and
  # b) provide it with the include files and libs it needs (C and C++ standard library)

  # These are also exposed as cling.flags because it's handy to be able to pass them
  # to tools that wrap Cling, particularly Jupyter kernels such as xeus-cling and the built-in
  # jupyter-cling-kernel. Both of these use Cling as a library by linking against
  # libclingJupyter.so, so the makeWrapper approach to wrapping the binary doesn't work.
  # Thus, if you're packaging a Jupyter kernel, you either need to pass these flags as extra
  # args to xcpp (for xeus-cling) or put them in the environment variable CLING_OPTS
  # (for jupyter-cling-kernel)
  flags = [
    "-nostdinc"
    "-nostdinc++"
    "-I" "${gcc-unwrapped}/include/c++/9.3.0"
    "-I" "${clingUnwrapped}/include"
    "-I" "${glibc.dev}/include"
    "-I" "${gcc-unwrapped}/include/c++/9.3.0/x86_64-unknown-linux-gnu"
    "-I" "${clingUnwrapped}/lib/clang/5.0.2/include"
    "-L" "${clingUnwrapped}/lib"
  ];

  cling = runCommand "cling-isolated" {
    buildInputs = [makeWrapper];
    inherit clingUnwrapped;
    inherit flags;
  } ''
    makeWrapper $clingUnwrapped/bin/cling $out/bin/cling \
      --add-flags "$flags"
  '';
in

cling // {
  unwrapped = clingUnwrapped;
  flags = flags;
}
