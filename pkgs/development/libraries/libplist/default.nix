{ stdenv,  autoreconfHook, fetchFromGitHub, pkgconfig, python2Packages, glib }:

let
  inherit (python2Packages) python cython;
in
stdenv.mkDerivation rec {
  pname = "libplist";
  version = "2019-04-04";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "42bb64ba966082b440cb68cbdadf317f44710017";
    sha256 = "19yw80yblq29i2jx9yb7bx0lfychy9dncri3fk4as35kq5bf26i8";
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
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.linux;
  };
}
