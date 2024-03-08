{ re, reason, pastel, ... }:

{
  pname = "cli";

  nativeBuildInputs = [
    reason
  ];

  buildInputs = [
    re
    pastel
  ];
}
