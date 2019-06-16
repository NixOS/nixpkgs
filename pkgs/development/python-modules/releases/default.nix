{ buildPythonPackage
, lib
, fetchPypi
, sphinx
, semantic-version
}:

buildPythonPackage rec {
  version = "1.6.1";
  pname = "releases";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m6skhfdjmfgwn7f3dhzdwa6sxamy0fzbn319vf42b86mdik26vs";
  };

  propagatedBuildInputs = [ semantic-version sphinx ];

  # Use compatible sphinx versions
  postPatch = ''
    substituteInPlace setup.py \
      --replace "sphinx>=1.3,<1.8" "sphinx ~= 1.3"
  '';

  # Tests excluded from sdist package
  doCheck = false;

  meta = with lib; {
    description = "A Sphinx extension for changelog manipulation";
    homepage = https://github.com/bitprophet/releases;
    license = licenses.bsd2;
    maintainers = with maintainers; [ jonringer ];
  };
}
