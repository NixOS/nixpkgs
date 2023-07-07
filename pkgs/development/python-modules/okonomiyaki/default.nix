{ buildPythonPackage
, stdenv
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

  src = fetchFromGitHub {
    owner = "enthought";
    repo = pname;
    rev = version;
    hash = "sha256-eWCOuGtdjBGThAyu15aerclkSWC593VGDPHJ98l30iY=";
  };

  propagatedBuildInputs = [ distro attrs jsonschema six zipfile2 ];

  preCheck = ''
    substituteInPlace okonomiyaki/runtimes/tests/test_runtime.py \
      --replace 'runtime_info = PythonRuntime.from_running_python()' 'raise unittest.SkipTest() #'
   '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace okonomiyaki/platforms/tests/test_pep425.py \
      --replace 'self.assertEqual(platform_tag, self.tag.platform)' 'raise unittest.SkipTest()'
  '';

  checkInputs = [ hypothesis mock packaging testfixtures ];

  pythonImportsCheck = [ "okonomiyaki" ];

  meta = with lib; {
    homepage = "https://github.com/enthought/okonomiyaki";
    description = "An experimental library aimed at consolidating a lot of low-level code used for Enthought's eggs";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
