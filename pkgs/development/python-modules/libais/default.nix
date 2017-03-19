{ stdenv, buildPythonPackage, fetchurl,
  six, pytest, pytestrunner, pytestcov, coverage
}:
buildPythonPackage rec {
  name = "libais-${version}";
  version = "0.16";

  src = fetchurl {
    url = "mirror://pypi/l/libais/${name}.tar.bz2";
    sha256 = "14dsh5k32ryszwdn6p45wrqp4ska6cc9qpm6lk5c5d1p4rc7wnhq";
  };

  # data files missing
  doCheck = false;

  buildInputs = [ pytest pytestrunner pytestcov coverage ];
  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/schwehr/libais;
    description = "Library for decoding maritime Automatic Identification System messages";
    license = licenses.asl20;
    platforms = platforms.linux;  # It currently fails to build on darwin
  };
}
