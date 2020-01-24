{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "pypattyrn";
  version = "1.2";
  
  src = fetchFromGitHub {
    owner = "tylerlaberge";
	repo = "PyPattyrn";
    rev = "v${version}";
    sha256 = "1cyan39h9wh0piycp2s9vbqp4066acny3aa24y55cvgh51sqcm0v";
  };
    
  meta = with lib; {
    description = "Design Pattern Templates for Python";
    homepage = "https://github.com/tylerlaberge/PyPattyrn";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
