{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, writeShellScript
, pkg-config
, texinfo
, pcre2
, swig
, libxml2
, ncurses
, enablePython ? false
, python ? null
}:
let
  isPython3 = enablePython && python.pythonAtLeast "3";
in
stdenv.mkDerivation rec {
  pname = "libredwg";
  version = "0.12.5.6313";

  src = fetchFromGitHub {
    owner = "LibreDWG";
    repo = pname;
    rev = version;
    hash = "sha256-TM+cZ7N5PD6UG9cvy0XFa0sNYc3apbAJvEMh3husjRk=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-26157.patch";
      url = "https://github.com/LibreDWG/libredwg/commit/c8cf03ce4c2315b146caf582ea061c0460193bcc.patch";
      hash = "sha256-EEF3YYPW+6SvXRiAw3zz6tWU9w/qmGtc09Tf8wn7hVc=";
    })
  ];

  postPatch = let
    printVersion = writeShellScript "print-version" ''
      echo -n ${lib.escapeShellArg version}
    '';
  in ''
    # avoid git dependency
    cp ${printVersion} build-aux/git-version-gen
    # failing to build otherwise since glibc-2.38
    sed '1i#include <string.h>' -i programs/dwg2SVG.c
  '';

  preConfigure = lib.optionalString (stdenv.isDarwin && enablePython) ''
    # prevent configure picking up stack_size from distutils.sysconfig
    export PYTHON_EXTRA_LDFLAGS=" "
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config texinfo ]
    ++ lib.optional enablePython swig;

  buildInputs = [ pcre2 ]
    ++ lib.optionals enablePython [ python ]
    # configurePhase fails with python 3 when ncurses is missing
    ++ lib.optional isPython3 ncurses
  ;

  # prevent python tests from running when not building with python
  configureFlags = lib.optional (!enablePython) "--disable-python";

  # example_r13.dxf roundtrip fail: expect 5286, got 5285 entities
  doCheck = !(stdenv.isLinux && stdenv.isAarch64);

  # the "xmlsuite" test requires the libxml2 c library as well as the python module
  nativeCheckInputs = lib.optionals enablePython [ libxml2 libxml2.dev ];

  meta = with lib; {
    description = "Free implementation of the DWG file format";
    homepage = "https://savannah.gnu.org/projects/libredwg/";
    maintainers = with maintainers; [ tweber ];
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
