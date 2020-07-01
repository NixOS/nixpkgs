{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "playsound";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "TaylorSMarks";
    repo = "playsound";
    rev = "907f1fe73375a2156f7e0900c4b42c0a60fa1d00";
    sha256 = "1fh3m115h0c57lj2pfhhqhmsh5awzblb7csi1xc5a6f6slhl059k";
  };

  doCheck = false;

  pythonImportsCheck = [ "playsound" ];

  meta = with lib; {
    homepage = "https://github.com/TaylorSMarks/playsound";
    description = "Pure Python, cross platform, single function module with no dependencies for playing sounds";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ luc65r ];
  };
}
