{ stdenv, buildPythonPackage, fetchurl, click }:

buildPythonPackage rec {
  version = "0.2.0";
  name = "click-log-${version}";

  src = fetchurl {
    url = "mirror://pypi/c/click-log/${name}.tar.gz";
    sha256 = "1bjrfxji1yv4fj0g78ri2yfgn2wbivn8g69fxfinxvxpmighhshp";
  };

  propagatedBuildInputs = [ click ];

  meta = with stdenv.lib; {
    homepage = https://github.com/click-contrib/click-log/;
    description = "Logging integration for Click";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

