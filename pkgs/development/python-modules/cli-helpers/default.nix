{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, configobj
, mock
, pytestCheckHook
, tabulate
, wcwidth
}:

buildPythonPackage rec {
  pname = "cli_helpers";
  version = "2.2.0";

  # PyPi only carries py3 wheel
  src = fetchFromGitHub {
    owner = "dbcli";
    repo = pname;
    rev = "v${version}";
    sha256 = "19npq8snc3ycbjapqdjp7274rcj9rszf1c7iyp346rclb6w6ay6j";
  };

  propagatedBuildInputs = [
    configobj
    tabulate
    wcwidth
  ];

  disabled = pythonOlder "3.6";

  checkInputs = [ pytestCheckHook mock ];

  pythonImportsCheck = [ "cli_helpers" ];

  meta = with lib; {
    description = "Python helpers for common CLI tasks";
    longDescription = ''
      CLI Helpers is a Python package that makes it easy to perform common
      tasks when building command-line apps. It's a helper library for
      command-line interfaces.

      Libraries like Click and Python Prompt Toolkit are amazing tools that
      help you create quality apps. CLI Helpers complements these libraries by
      wrapping up common tasks in simple interfaces.

      CLI Helpers is not focused on your app's design pattern or framework --
      you can use it on its own or in combination with other libraries. It's
      lightweight and easy to extend.

      What's included in CLI Helpers?

      - Prettyprinting of tabular data with custom pre-processing
      - [in progress] config file reading/writing

      Read the documentation at http://cli-helpers.rtfd.io
    '';
    homepage = "https://cli-helpers.readthedocs.io/en/stable/";
    license = licenses.bsd3;
    changelog = "https://github.com/dbcli/cli_helpers/raw/v${version}/CHANGELOG";
    maintainers = [ maintainers.kalbasit ];
  };
}
