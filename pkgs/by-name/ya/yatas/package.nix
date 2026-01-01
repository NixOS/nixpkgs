{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "yatas";
<<<<<<< HEAD
  version = "1.6.1";
=======
  version = "1.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "padok-team";
    repo = "YATAS";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-fkMrQqHtlZWoJZgSu1KeZ+p1pWXFUYYIUOkvd/DHx8k=";
  };

  vendorHash = "sha256-NJO/eankcoM9FsYz7jop1tY0ueeNyVG2TEip5F46haI=";
=======
    hash = "sha256-gw4aZ7SLUz5WLUb1z4zDtI6Ca0tEWhE5wobp5NRvjkg=";
  };

  vendorHash = "sha256-zp5EVJe5Q6o6C0CZ8u+oEFEOy0NU5SgVN+cSc6A/jZ4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Tool to audit AWS infrastructure for misconfiguration or potential security issues";
    homepage = "https://github.com/padok-team/YATAS";
    changelog = "https://github.com/padok-team/YATAS/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "yatas";
  };
}
