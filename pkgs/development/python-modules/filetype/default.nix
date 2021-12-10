{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "filetype";
  version = "1.0.8";

  src = fetchFromGitHub {
     owner = "h2non";
     repo = "filetype.py";
     rev = "v1.0.8";
     sha256 = "1hib7h2lg58mnck1l1vhg2j1svyyj5pcmg81xpc7v7sjl80idpih";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Infer file type and MIME type of any file/buffer";
    homepage = "https://github.com/h2non/filetype.py";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
