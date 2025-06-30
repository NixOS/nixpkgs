{
  ruamel-yaml,
}:

ruamel-yaml.overrideAttrs (prev: rec {
  version = "0.17.21";

  patches = [ ];

  src = prev.src.overrideAttrs {
    rev = version;
    hash = "sha256-6PV0NyPQfd+4RBqoj5vJaOHShx+TJVHD2IamRinU0VU=";
  };
})
