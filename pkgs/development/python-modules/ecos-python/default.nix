{ lib, buildPythonPackage, fetchFromGitHub, fetchPypi, nose, numpy, scipy }:

buildPythonPackage rec {
  pname = "ecos";
  version = "2.0.7.post1";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "83e90f42b3f32e2a93f255c3cfad2da78dbd859119e93844c45d2fca20bdc758";
  };
  
  # submodule is only part of PyPI tarball, which does not include the test files
  testSrc = fetchFromGitHub {
    owner = "embotech";
    repo = "ecos-python";
    rev = "2.0.7";
    sha256 = "0y7rgn3329sx7i82wf567x3cq0jxs27cnif299mj8y4zdglmvfqn";
  };
  
  patchPhase = ''
    cp ${testSrc}/src/test_interface.py ${testSrc}/src/test_interface_bb.py src
  '';

  propagatedBuildInputs = [ numpy scipy ];
  
  checkInputs = [ nose ];
  
  meta = with lib; {
    description = "Lightweight conic solver for second-order cone programming";
    homepage = "https://github.com/embotech/ecos";
    license = licenses.gpl3;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
