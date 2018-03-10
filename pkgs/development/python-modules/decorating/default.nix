{ stdenv, fetchPypi,
  buildPythonPackage, isPy27, isPy34, isPy35, isPy36
}:

buildPythonPackage rec {
  pname = "decorating";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10s8fg9pm4aq88giq98c0rqa6r7pv622x3ywncq1anih1brxyvkn";
  };

  propagatedBuildInputs = [];

  disabled = !(isPy27 || isPy34 || isPy35 || isPy36);

  meta = with stdenv.lib; {
    description = "A useful collection of decorators";
    homepage    = "https://github.com/ryukinix/mal";
    maintainers = [ maintainers.taktoa ];
    license     = licenses.mit;
  };
}
