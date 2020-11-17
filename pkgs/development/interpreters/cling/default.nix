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
  callPackage,

  # Provide flags to Cling to prevent it from looking for system include paths,
  # and pass it the paths to glibc and the LLVM C++
  isolate ? true,

  # Produce a "standalone" version of Cling, suitable for running as an executable.
  # If set to false, the output will include extra files for using Cling as a library.
  standalone ? false
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

  cling = runCommand "cling-isolated" {
    buildInputs = [makeWrapper];
    inherit clingUnwrapped;
  } ''
    makeWrapper $clingUnwrapped/bin/cling $out/bin/cling \
      --add-flags "${envToUse.lib.concatStringsSep " " (callPackage ./flags.nix {cling = clingUnwrapped;})}"
  '';
in

cling // { unwrapped = clingUnwrapped; }
