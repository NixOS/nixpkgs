{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "taskctl";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-pppUeLc7kZPDYiZRJ+NJDvPlQwRNmDhBpocAQTqtc5A=";
  };

  vendorHash = "sha256-LYoOp00z8+ifsLvmM7o1/+QVoNJI4+kLuXsNM5KIcnM=";

  ldflags = [ "-w" "-s" ];

  meta = with lib; {
    homepage = "https://github.com/taskctl/taskctl";
    description = "Concurrent task runner, developer's routine tasks automation toolkit. Simple modern alternative to GNU Make";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ rs0vere ];
  };
}
