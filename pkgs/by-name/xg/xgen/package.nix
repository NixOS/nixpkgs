{ lib, buildGoModule, fetchFromGitHub }:


buildGoModule rec {
  pname = "xgen";

  # This is a pseudoversion including the fetch date and git hash.
  # The upstream project does not provide official releases or version tags.
  version = "v0-unstable-2023-07-02";

  src = fetchFromGitHub {
    owner = "xuri";
    repo = "xgen";
    rev = "db840e1a460537cf4f90c2a88cffe11ef354dd9f";
    sha256 = "sha256-S5F7I6rDxtLSVlq7VLJkfghX+scudK9WZmOcDHmehM8=";
  };

  vendorHash = "sha256-YU/iQnZs4/oUiJw3syW1jxEpeQLyOMElsjzWCNsucds=";

  meta = with lib; {
    description = "A XSD to Go/C/Java/Rust/TypeScript code generator";
    homepage = "https://github.com/xuri/xgen";
    license = licenses.bsd3;
    maintainers = with maintainers; [ imalsogreg ];
    mainProgram = "xgen";
  };
}

