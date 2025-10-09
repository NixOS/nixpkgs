{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.9.2";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-/qz93JmMkJW3+lzT+QKvb/VL+xmbg5H8kKaXK+XN2nE=";
  };

  propagatedBuildInputs = [ qtbase ];
}
