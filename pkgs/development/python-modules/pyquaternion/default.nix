{ lib
, buildPythonPackage
, fetchPypi
, numpy
, nose
}:

buildPythonPackage rec {
  pname = "pyquaternion";
  version = "0.9.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sfYa8hnLL+lmtft5oZISTy5jo/end6w8rfKVexqBvqg=";
  };

  # The VERSION.txt file is required for setup.py
  # See: https://github.com/KieranWynn/pyquaternion/blob/master/setup.py#L14-L15
  postPatch = ''
    echo "${version}" > VERSION.txt
  '';

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ nose ];
  pythonImportsCheck = [ "pyquaternion" ];

  meta = with lib; {
    description = "Library for representing and using quaternions.";
    homepage = "http://kieranwynn.github.io/pyquaternion/";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
