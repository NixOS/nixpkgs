{ buildPythonPackage
, fetchFromGitHub
, lib

, attrs
, distro
, jsonschema
, six
, zipfile2

, hypothesis
, mock
, packaging
, testfixtures
}:

buildPythonPackage rec {
  pname = "okonomiyaki";
  version = "1.3.2";

  propagatedBuildInputs = [ distro attrs jsonschema six zipfile2 ];

  preCheck = "sed 's/runtime_info = PythonRuntime.from_running_python()/raise unittest.SkipTest() #/' -i /build/source/okonomiyaki/runtimes/tests/test_runtime.py";
  checkInputs = [ hypothesis mock packaging testfixtures ];

  src = fetchFromGitHub {
    owner = "enthought";
    repo = pname;
    rev = version;
    hash = "sha256-eWCOuGtdjBGThAyu15aerclkSWC593VGDPHJ98l30iY=";
  };

  meta = with lib; {
    homepage = "https://github.com/enthought/okonomiyaki";
    description = "Okonomiyaki is an experimental library aimed at consolidating a lot of our low-level code used for Enthought's eggs";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };

}
