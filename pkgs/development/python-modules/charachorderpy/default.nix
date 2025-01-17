{ buildPythonPackage, fetchFromGitHub, lib, pyserial, pythonOlder }:

buildPythonPackage rec {
  pname = "charachorder-py";
  version = "0.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "GetPsyched";
    repo = "charachorder.py";
    rev = "v${version}";
    sha256 = "sha256-30kGAa+urBZjcg3pYUwejTjIwmSRiAQUXC8GXWhPynE=";
  };

  nativeBuildInputs = [ pyserial ];

  meta = with lib; {
    description = "A wrapper for CharaChorder's Serial API written in Python";
    downloadPage = "https://pypi.org/project/charachorder.py/#files";
    homepage = "https://github.com/GetPsyched/charachorder.py";
    license = licenses.mit;
    maintainers = [ maintainers.getpsyched ];
    platforms = platforms.all;
    sourceProvenance = [ sourceTypes.fromSource ];
  };
}
