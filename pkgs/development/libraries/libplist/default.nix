{ stdenv,  autoreconfHook, fetchFromGitHub, pkgconfig, python2Packages, glib }:

let
  inherit (python2Packages) python cython;
in
stdenv.mkDerivation rec {
  pname = "libplist";
  version = "2019-01-20";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "bec850fe399639f3b8582a39386216970dea15ed";
    sha256 = "197yw8xz8x2xld8b6975scgnl30j4ibm9llmzljyqngs0zsdwnin";
  };

  outputs = ["bin" "dev" "out" "py"];

  nativeBuildInputs = [
    pkgconfig
    python
    cython
    autoreconfHook
  ];

  propagatedBuildInputs = [ glib ];

  postFixup = ''
    moveToOutput "lib/${python.libPrefix}" "$py"
  '';

  meta = with stdenv.lib; {
    description = "A library to handle Apple Property List format in binary or XML";
    homepage = https://github.com/libimobiledevice/libplist;
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
