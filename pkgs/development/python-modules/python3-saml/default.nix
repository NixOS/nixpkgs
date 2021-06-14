{ lib, fetchurl, fetchFromGitHub, buildPythonPackage, isPy3k,
isodate, lxml, xmlsec, freezegun }:

buildPythonPackage rec {
  pname = "python3-saml";
  version = "1.10.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "onelogin";
    repo = "python3-saml";
    rev = "v${version}";
    sha256 = "1yk02xq90bm7p6k091av6gapb5h2ccxzgrbm03sj2x8h0wff9s8k";
  };

  patches = [
    # Remove the dependency on defusedxml
    #
    # This patch is already merged upstream and does not introduce any
    # functionality changes.
    (fetchurl {
      url = "https://github.com/onelogin/python3-saml/commit/4b6c4b1f2ed3f6eab70ff4391e595b808ace168c.patch";
      sha256 = "11gqn7ib2hmlx5wp4xhi375v5ajapwmj4lpw0y44bh5ww8cypvqy";
    })
  ];

  propagatedBuildInputs = [
    isodate lxml xmlsec
  ];

  checkInputs = [ freezegun ];
  pythonImportsCheck = [ "onelogin.saml2" ];

  meta = with lib; {
    description = "OneLogin's SAML Python Toolkit for Python 3";
    homepage = "https://github.com/onelogin/python3-saml";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
