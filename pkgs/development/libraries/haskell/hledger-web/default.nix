{ cabal, blazeHtml, blazeMarkup, clientsession, cmdargs
, dataDefault, filepath, hamlet, hjsmin, hledger, hledgerLib
, httpConduit, HUnit, ioStorage, monadControl, networkConduit
, parsec, regexpr, safe, shakespeareCss, shakespeareJs
, shakespeareText, text, time, transformers, wai, waiExtra, warp
, yaml, yesod, yesodCore, yesodDefault, yesodForm, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.19.3";
  sha256 = "1kx5mn6drm90clz132vrd2lkssm73hlwvxb9cxg6z82i5qa9jqn9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml blazeMarkup clientsession cmdargs dataDefault filepath
    hamlet hjsmin hledger hledgerLib httpConduit HUnit ioStorage
    monadControl networkConduit parsec regexpr safe shakespeareCss
    shakespeareJs shakespeareText text time transformers wai waiExtra
    warp yaml yesod yesodCore yesodDefault yesodForm yesodStatic
  ];
  patchPhase = ''
    sed -r -i -e 's|blaze-html * >= 0.5 *&& < 0.6|blaze-html >= 0.5|' hledger-web.cabal
  '';
  jailbreak = true;
  meta = {
    homepage = "http://hledger.org";
    description = "A web interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
