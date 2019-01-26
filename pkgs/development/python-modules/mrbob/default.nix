{ buildPythonPackage, stdenv, glibcLocales, mock, nose, isPy3k, jinja2, six
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mrbob";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6737eaf98aaeae85e07ebef844ee5156df2f06a8b28d7c3dcb056f811c588121";
  };

  disabled = isPy3k;

  checkInputs = [ nose glibcLocales mock ];
  checkPhase = ''
    LC_ALL="en_US.UTF-8" nosetests
  '';

  propagatedBuildInputs = [ jinja2 six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/domenkozar/mr.bob;
    description = "A tool to generate code skeletons from templates";
    license = licenses.bsd3;
  };
}
