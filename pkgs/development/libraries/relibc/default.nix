{ stdenvNoCC, buildPackages, fetchurl }:

stdenvNoCC.mkDerivation {
  name = "binary-relibc-latest";

  # snapshot of https://static.redox-os.org/toolchain/x86_64-unknown-redox/relibc-install.tar.gz
  src = fetchurl {
    name = "relibc-install.tar.gz";
    url = "https://gateway.pinata.cloud/ipfs/QmNp6fPTjPA6LnCYvW1UmbAHcPpU7tqZhstfSpSXMJCRwp";
    sha256 = "1hjdzrj67jdag3pm8h2dqh6xipbfxr6f4navdra6q1h83gl7jkd9";
  };

  # to avoid "unpacker produced multiple directories"
  unpackPhase = "unpackFile $src";

  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;
  installPhase = ''
    mkdir $out/
    cp -r x86_64-unknown-redox/* $out/
    rm -rf $out/bin
  '';

  meta = with stdenvNoCC.lib; {
    homepage = "https://gitlab.redox-os.org/redox-os/relibc";
    description = "C Library in Rust for Redox and Linux";
    license = licenses.mit;
    maintainers = [ maintainers.aaronjanse ];
    platforms = platforms.redox;
  };
}
