{ stdenv, lib, fetchzip, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "miranda";
  version = "2.066";

  # The build generates object files (`.x`) from module files (`.m`).
  # To be able to invalidate object file, it contains the `mtime`
  # of the corresponding module file at the time of the build.
  # When a file is installed to Nix store its `mtime` is set to `1`,
  # so the `mtime` field in the object file would no longer match
  # and Miranda would try to regenerate it at the runtime,
  # even though it is up to date.
  # Using `fetchzip` will make all the source files have `mtime=1`
  # from the start so this mismatch cannot occur.
  src = fetchzip {
    url = "https://www.cs.kent.ac.uk/people/staff/dat/miranda/src/mira-${builtins.replaceStrings [ "." ] [ "" ] version}-src.tgz";
    sha256 = "KE/FTL9YW9l7VBAgkFZlqgSM1Bt/BXT6GkkONtyKJjQ=";
  };

  patches = [
    # Allow passing `PREFIX` to makeFlags.
    # Sent upstream on 2020-10-10.
    (fetchpatch {
      name = "fix-makefile-variables.patch";
      url = "https://github.com/jtojnar/miranda/commit/be62d2150725a4c314aa7e3e1e75a165c90be65d.patch";
      sha256 = "0r8nnr7iyzp1a3w3n6y1xi0ralqhm1ifp75yhyj3h1g229vk51a6";
    })

    # Create the installation directories.
    # Sent upstream on 2020-10-10.
    (fetchpatch {
      name = "add-mkdirs-makefile.patch";
      url = "https://github.com/jtojnar/miranda/commit/048754606625975d5358e946549c41ae7b5d3428.patch";
      sha256 = "1n8xv679i7s789km2dxxrs2pphyyi7vr7rhafqvmkcdmhmxk9h2a";
    })

    # Use correct installation path for finding the library.
    # Sent upstream on 2020-10-10.
    (fetchpatch {
      name = "c-path-fixes.patch";
      url = "https://github.com/jtojnar/miranda/commit/aea0a118a802a0da6029b781f7cfd388224263cf.patch";
      sha256 = "1z3giv8fzc35a23ga9ahz9d1fbvya67kavnb8h4rv2icbzr5j5gd";
    })

    # Make build reproducible.
    # Sent upstream on 2020-10-10.
    (fetchpatch {
      name = "deterministic-build.patch";
      url = "https://github.com/jtojnar/miranda/commit/daf8abb8f30ec1cca21698e3fc355578b9f7c571.patch";
      sha256 = "TC/YrHrMzdlwicJ3oJ/TjwhkufmV3ypemgyqhMmVut4=";
    })
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: types.o:(.bss+0x11b0): multiple definition of `current_file'; y.tab.o:(.bss+0x70): first defined here
  env.NIX_CFLAGS_COMPILE = toString ([
    "-fcommon"
  ] ++ lib.optionals stdenv.cc.isClang [
    "-Wno-error=int-conversion"
  ]);

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CFLAGS=-O2"
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs quotehostinfo
    substituteInPlace Makefile --replace strip '${stdenv.cc.targetPrefix}strip'
  '';

  meta = with lib; {
    description = "Compiler for Miranda -- a pure, non-strict, polymorphic, higher order functional programming language";
    homepage = "https://www.cs.kent.ac.uk/people/staff/dat/miranda/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.all;
    mainProgram = "mira";
  };
}
