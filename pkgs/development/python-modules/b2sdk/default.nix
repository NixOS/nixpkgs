{ lib, buildPythonPackage, fetchPypi, mock, pyflakes, yapf, nose, arrow, logfury, requests, setuptools, six, tqdm}:

buildPythonPackage rec {
  pname = "b2sdk";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "143knykrlsdmk0748s4m7blp71r5n2bnk2gbsn72jlhn81zjyh0h";
  };

	postPatch = ''
		sed 's/==\([0-9]\.\?\)\+//' -i requirements-test.txt
	  substituteInPlace requirements-test.txt --replace "liccheck" ""
  '';

	checkInputs = [ mock pyflakes yapf nose ];
	propagatedBuildInputs = [ arrow logfury requests setuptools six tqdm yapf ];

  meta = with lib; {
    homepage = https://github.com/Backblaze/b2-sdk-python;
    description = "Python library to access B2 cloud storage.";
    license = licenses.mit;
    maintainers = with maintainers; [ sdier ];
  };
}
