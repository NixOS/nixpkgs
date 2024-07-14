{
  lib,
  fetchPypi,
  buildPythonPackage,
  isPy3k,
  requests,
  flake8,
  mock,
  pytest,
  mystem,
}:

buildPythonPackage rec {
  pname = "pymystem3";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gq7WoVRRzHP1dQvNp3VZ5oEhXh45GzXdQyW9Eyo6+5U=";
  };

  propagatedBuildInputs = [ requests ];
  nativeCheckInputs = [
    flake8
    mock
    pytest
  ];
  doCheck = isPy3k; # fails on linting

  postPatch = ''
    sed -i 's#^_mystem_info = .*#_mystem_info = ["${mystem}/bin", "${mystem}/bin/mystem"]#' pymystem3/constants.py
  '';

  meta = with lib; {
    description = "Python wrapper for the Yandex MyStem 3.1 morpholocial analyzer of the Russian language";
    homepage = "https://github.com/nlpub/pymystem3";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
