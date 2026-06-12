{
  stdenv,
  lib,
  fetchFromCodeberg,
}:

stdenv.mkDerivation rec {
  pname = "varlpenis";
  version = "3.0.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "ssterling";
    repo = "varlpenis";
    tag = "v${version}";
    hash = "sha256-XfdflE+IsJSWgjafruVyC8KagQ+RC84A5PGYI6Fjni4=";
  };

  # fixes upstream typo in configure script ("$cd_pwd" instead of "$cs_pwd", causing the working directory check to fail)
  postPatch = ''
    substituteInPlace configure \
      --replace-fail 'cd "$cd_pwd"' 'cd "$cs_pwd"'
  '';

  # upstream defaults to BSD make options (ifndef_guards="yes")
  configureFlags = [ "--no-ifndef-guards" ];

  meta = {
    description = "Generate an ASCII-art penis of arbitrary length";
    homepage = "https://codeberg.org/ssterling/varlpenis";
    license = lib.licenses.mit;
    mainProgram = "varlpenis";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ starhaze ];
  };
}
