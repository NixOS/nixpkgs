{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "yatas";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "padok-team";
    repo = "YATAS";
    rev = "refs/tags/v${version}";
    hash = "sha256-gw4aZ7SLUz5WLUb1z4zDtI6Ca0tEWhE5wobp5NRvjkg=";
  };

  vendorHash = "sha256-zp5EVJe5Q6o6C0CZ8u+oEFEOy0NU5SgVN+cSc6A/jZ4=";

  meta = with lib; {
    description = "Tool to audit AWS infrastructure for misconfiguration or potential security issues";
    homepage = "https://github.com/padok-team/YATAS";
    changelog = "https://github.com/padok-team/YATAS/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "yatas";
  };
}
