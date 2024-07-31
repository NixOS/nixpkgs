{ lib, buildPythonPackage, fetchPypi, isPy3k
, setuptools-scm
, beancount
, pytestCheckHook, sh
}:

buildPythonPackage rec {
  version = "1.0.2";
  pname = "beancount_payeeverif";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "03gf07797nbx4f6khapmkjz1mgbhsiqv0pmrzkicd2qyaba65mwk";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    beancount
  ];

  checkInputs = [
    pytestCheckHook
    sh
  ];

  meta = with lib; {
    homepage = "https://github.com/siriobalmelli/beancount_payeeverif";
    description = "Payee verification plugin for Beancount";
    longDescription = ''
      beancount_payeeverif is the "payee verification" plugin for beancount,
      fulfilling the following functions:

      Every transaction has a non-NULL payee field:

      ; this will throw an error
      2020-06-01  *   ""   "fix faucet leak"
        Expenses:General
        Assets:Bank -150 bean

      ; this will pass validation
      2020-06-02  *   "plumber"   "fix faucet leak"
        Expenses:General
        Assets:Bank -150 bean

      *TODO: coming soon* Transactions touching certain accounts
      must match an allowed_payees regex.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
