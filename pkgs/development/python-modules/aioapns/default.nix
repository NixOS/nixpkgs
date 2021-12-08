{ buildPythonPackage
, fetchFromGitHub
, h2
, lib
, pyjwt
, pyopenssl
}:

buildPythonPackage rec {
  pname = "aioapns";
  version = "2.0.2";

  src = fetchFromGitHub {
     owner = "Fatal1ty";
     repo = "aioapns";
     rev = "v2.0.2";
     sha256 = "1k3j3ciffzvyvia1h2abn6y4w7w2ckfbcs8d4apx4wyp1gwnf05w";
  };

  propagatedBuildInputs = [
    h2
    pyopenssl
    pyjwt
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioapns" ];

  meta = with lib; {
    description = "An efficient APNs Client Library for Python/asyncio";
    homepage = "https://github.com/Fatal1ty/aioapns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
