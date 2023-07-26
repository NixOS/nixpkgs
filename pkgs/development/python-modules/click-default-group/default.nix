{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, click
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-default-group";
  version = "1.2.2";

  # No tests in Pypi tarball
  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-default-group";
    rev = "v${version}";
    sha256 = "0nk39lmkn208w8kvq6f4h3a6qzxrrvxixahpips6ik3zflbkss86";
  };

  patches = [
    # make tests compatible with click 8
    (fetchpatch {
      url = "https://github.com/click-contrib/click-default-group/commit/9415c77d05cf7d16876e7d70a49a41a6189983b4.patch";
      sha256 = "1czzma8nmwyxhwhnr8rfw5bjw6d46b3s5r5bfb8ly3sjwqjlwhw2";
    })
  ];

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "click_default_group" ];

  meta = with lib; {
    homepage = "https://github.com/click-contrib/click-default-group";
    description = "Group to invoke a command without explicit subcommand name";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
