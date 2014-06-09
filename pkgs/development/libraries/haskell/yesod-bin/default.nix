{ cabal, attoparsec, base64Bytestring, blazeBuilder, Cabal, conduit
, conduitExtra, dataDefaultClass, fileEmbed, filepath, fsnotify
, ghcPaths, httpConduit, httpReverseProxy, httpTypes, liftedBase
, network, networkConduit, optparseApplicative, parsec
, projectTemplate, resourcet, shakespeare, shakespeareCss
, shakespeareJs, shakespeareText, split, streamingCommons
, systemFileio, systemFilepath, tar, text, time, transformers
, unixCompat, unorderedContainers, wai, waiExtra, warp, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "yesod-bin";
  version = "1.2.9.3";
  sha256 = "1gjcg798d7xpd8hgz8s1napgxm9dnbsks1g1s5hgx8ml5xkp2la7";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    attoparsec base64Bytestring blazeBuilder Cabal conduit conduitExtra
    dataDefaultClass fileEmbed filepath fsnotify ghcPaths httpConduit
    httpReverseProxy httpTypes liftedBase network networkConduit
    optparseApplicative parsec projectTemplate resourcet shakespeare
    shakespeareCss shakespeareJs shakespeareText split streamingCommons
    systemFileio systemFilepath tar text time transformers unixCompat
    unorderedContainers wai waiExtra warp yaml zlib
  ];

  postInstall = ''
    mv $out/bin/yesod $out/bin/.yesod-wrapped
    cat - > $out/bin/yesod <<EOF
    #! ${self.stdenv.shell}
    export HSENV=1
    export PACKAGE_DB_FOR_GHC='$( ${self.ghc.GHCGetPackages} ${self.ghc.version} | tr " " "\n" | tail -n +2 | paste -d " " - - | sed 's/.*/-g "&"/' | tr "\n" " ")'
    eval exec $out/bin/.yesod-wrapped "\$@"
    EOF
    chmod +x $out/bin/yesod
  '';

  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "The yesod helper executable";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
