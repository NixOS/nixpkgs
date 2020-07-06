{ lib, buildPythonPackage, fetchzip, pytest, asttokens }:

buildPythonPackage rec {
  pname = "executing";
  version = "0.4.3";

  src = fetchzip {
    url = "https://github.com/alexmojaki/executing/archive/v${version}.tar.gz";
    sha256 = "1fqfc26nl703nsx2flzf7x4mgr3rpbd8pnn9c195rca648zhi3nh";
  };

  checkInputs = [ pytest asttokens ];

  meta = with lib; {
    description = "Get information about what a frame is currently doing, particularly the AST node being executed";
    homepage = "https://github.com/alexmojaki/executing";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
  };
}
