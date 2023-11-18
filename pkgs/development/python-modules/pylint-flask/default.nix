{ buildPythonPackage
, fetchPypi
, isPy3k
, lib

# pythonPackages
, pylint-plugin-utils
}:

buildPythonPackage rec {
  pname = "pylint-flask";
  version = "0.6";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "05qmwgkpvaa5k05abqjxfbrfk3wpdqb8ph690z7bzxvb47i7vngl";
  };

  propagatedBuildInputs = [
    pylint-plugin-utils
  ];

  # Tests require a very old version of pylint
  #   also tests are only available at GitHub, with an old release tag
  doCheck = false;

  meta = with lib; {
    description = "A Pylint plugin to analyze Flask applications";
    homepage = "https://github.com/jschaf/pylint-flask";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
