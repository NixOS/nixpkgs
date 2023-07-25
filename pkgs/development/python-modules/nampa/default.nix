{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "nampa";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "thebabush";
    repo = pname;
    rev = version;
    sha256 = "14b6xjm497wrfw4kv24zhsvz2l6zknvx36w8i754hfwz3s3fsl6a";
  };

  propagatedBuildInputs = [
    future
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # https://github.com/thebabush/nampa/pull/13
    substituteInPlace setup.py \
      --replace "0.1.1" "${version}"
  '';

  pythonImportsCheck = [ "nampa" ];

  meta = with lib; {
    description = "Python implementation of the FLIRT technology";
    homepage = "https://github.com/thebabush/nampa";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
