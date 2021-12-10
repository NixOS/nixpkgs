{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "glob2";
  version = "0.7";

  src = fetchFromGitHub {
     owner = "miracle2k";
     repo = "python-glob2";
     rev = "v0.7";
     sha256 = "160nh2ay9lw2hi0rixpzb2k87r6ql56k0j2cm87lqz8xc8zbw919";
  };

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  meta = with lib; {
    description = "Version of the glob module that can capture patterns and supports recursive wildcards";
    homepage = "https://github.com/miracle2k/python-glob2/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
