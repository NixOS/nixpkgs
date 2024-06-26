{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  version = "1.2.17";
  pname = "zlog";

  src = fetchFromGitHub {
    owner = "HardySimpson";
    repo = pname;
    rev = version;
    sha256 = "sha256-ckpDMRLxObpl8N539DC5u2bPpmD7jM+KugurUfta6tg=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2024-22857.patch";
      url = "https://github.com/HardySimpson/zlog/commit/c47f781a9f1e9604f5201e27d046d925d0d48ac4.patch";
      hash = "sha256-3FAAHJ2R/OpNpErWXptjEh0x370/jzvK2VhuUuyaOjE=";
    })
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Reliable, high-performance, thread safe, flexible, clear-model, pure C logging library";
    homepage = "https://hardysimpson.github.io/zlog/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.matthiasbeyer ];
    mainProgram = "zlog-chk-conf";
    platforms = platforms.unix;
  };
}
