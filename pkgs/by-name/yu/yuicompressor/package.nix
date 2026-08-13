{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yuicompressor";
  version = "2.4.8";

  src = fetchurl {
    url = "https://github.com/yui/yuicompressor/releases/download/v${finalAttrs.version}/yuicompressor-${finalAttrs.version}.jar";
    sha256 = "1qjxlak9hbl9zd3dl5ks0w4zx5z64wjsbk7ic73r1r45fasisdrh";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  buildCommand = ''
    mkdir -p $out/{bin,lib}
    ln -s $src $out/lib/yuicompressor.jar
    makeWrapper ${jre}/bin/java $out/bin/yuicompressor --add-flags \
     "-cp $out/lib/yuicompressor.jar com.yahoo.platform.yui.compressor.YUICompressor"
  '';

  meta = {
    description = "JavaScript and CSS minifier";
    mainProgram = "yuicompressor";
    homepage = "http://yui.github.io/yuicompressor/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jwiegley ];
    platforms = lib.platforms.all;
  };
})
