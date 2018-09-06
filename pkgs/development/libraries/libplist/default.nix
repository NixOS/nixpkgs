{ stdenv,  autoreconfHook, fetchFromGitHub, pkgconfig, python2Packages, glib }:

let
  inherit (python2Packages) python cython;
in
stdenv.mkDerivation rec {
  pname = "libplist";
  version = "2018-07-25";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "db68a9d1070b363eee93147f072f46526064acbc";
    sha256 = "0lxyb35jjg31m8dxhsv1jr2ccy5s19fsqzisy7lfjk46w7brs4h5";
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
