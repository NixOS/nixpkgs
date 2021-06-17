{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, ifaddr
, poetry-core
, pythonOlder
, requests
, six
, websocket-client
}:

buildPythonPackage rec {
  pname = "roonapi";
  version = "0.0.37";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pavoni";
    repo = "pyroon";
    rev = version;
    sha256 = "1hxr473z9h3kb91m3ygina58pfwfyjsv1yb29spxmnbzvk34rzzz";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    ifaddr
    requests
    six
    websocket-client
  ];

  patches = [
    # Switch to poetry-core, https://github.com/pavoni/pyroon/pull/43
    (fetchpatch {
      name = "use-peotry-core.patch";
      url = "https://github.com/pavoni/pyroon/commit/16f890314683a6c2700fa4da5c937559e2e24bea.patch";
      sha256 = "047bhimr72rwqqyjy7jkfzacdc2ycy81wbmgnvf7xyhgjw1jyvh5";
    })
  ];

  # Tests require access to the Roon API
  doCheck = false;

  pythonImportsCheck = [ "roonapi" ];

  meta = with lib; {
    description = "Python library to interface with the Roon API";
    homepage = "https://github.com/pavoni/pyroon";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
