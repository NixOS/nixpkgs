{ pkgs }:

let
  haskellPlatformPackages_2013_2_0_0 = pkgs.haskell.packages_ghc763.override {
    extension = self : super : {
      async                     = self.async_2_0_1_4;
      attoparsec                = self.attoparsec_0_10_4_0;
      caseInsensitive           = self.caseInsensitive_1_0_0_1;
      cgi                       = self.cgi_3001_1_7_5;
      fgl                       = self.fgl_5_4_2_4;
      GLUT                      = self.GLUT_2_4_0_0;
      GLURaw                    = self.GLURaw_1_3_0_0;
      haskellSrc                = self.haskellSrc_1_0_1_5;
      hashable                  = self.hashable_1_1_2_5;
      html                      = self.html_1_0_1_2;
      HTTP                      = self.HTTP_4000_2_8;
      HUnit                     = self.HUnit_1_2_5_2;
      mtl                       = self.mtl_2_1_2;
      network                   = self.network_2_4_1_2;
      OpenGL                    = self.OpenGL_2_8_0_0;
      OpenGLRaw                 = self.OpenGLRaw_1_3_0_0;
      parallel                  = self.parallel_3_2_0_3;
      parsec                    = self.parsec_3_1_3;
      QuickCheck                = self.QuickCheck_2_6;
      random                    = self.random_1_0_1_1;
      regexBase                 = self.regexBase_0_93_2;
      regexCompat               = self.regexCompat_0_95_1;
      regexPosix                = self.regexPosix_0_95_2;
      split                     = self.split_0_2_2;
      stm                       = self.stm_2_4_2;
      syb                       = self.syb_0_4_0;
      text                      = self.text_0_11_3_1;
      transformers              = self.transformers_0_3_0_0;
      unorderedContainers       = self.unorderedContainers_0_2_3_0;
      vector                    = self.vector_0_10_0_1;
      xhtml                     = self.xhtml_3000_2_1;
      zlib                      = self.zlib_0_5_4_1;
      cabalInstall              = self.cabalInstall_1_16_0_2;
      alex                      = self.alex_3_0_5;
      happy                     = self.happy_1_18_10;
      primitive                 = self.primitive_0_5_0_1; # semi-official, but specified
    };
  };

  haskellPlatformPackages_2012_4_0_0 = pkgs.haskell.packages_ghc742.override {
    extension = self : super : {
      async                     = self.async_2_0_1_3;
      cgi                       = self.cgi_3001_1_7_4;
      fgl                       = self.fgl_5_4_2_4;
      GLUT                      = self.GLUT_2_1_2_1;
      haskellSrc                = self.haskellSrc_1_0_1_5;
      html                      = self.html_1_0_1_2;
      HTTP                      = super.HTTP_4000_2_5.override { network = self.network_2_3_1_0; };
      HUnit                     = self.HUnit_1_2_5_1;
      mtl                       = self.mtl_2_1_2;
      network                   = self.network_2_3_1_0;
      OpenGL                    = self.OpenGL_2_2_3_1;
      parallel                  = self.parallel_3_2_0_3;
      parsec                    = self.parsec_3_1_3;
      QuickCheck                = self.QuickCheck_2_5_1_1;
      random                    = self.random_1_0_1_1;
      regexBase                 = self.regexBase_0_93_2;
      regexCompat               = self.regexCompat_0_95_1;
      regexPosix                = self.regexPosix_0_95_2;
      split                     = self.split_0_2_1_1;
      stm                       = self.stm_2_4;
      syb                       = self.syb_0_3_7;
      text                      = self.text_0_11_2_3;
      transformers              = self.transformers_0_3_0_0;
      vector                    = self.vector_0_10_0_1;
      xhtml                     = self.xhtml_3000_2_1;
      zlib                      = self.zlib_0_5_4_0;
      cabalInstall              = self.cabalInstall_0_14_0;
      alex                      = self.alex_3_0_2;
      happy                     = self.happy_1_18_10;
      primitive                 = self.primitive_0_5_0_1; # semi-official, but specified
    };
  };

  haskellPlatformPackages_2012_2_0_0 = pkgs.haskell.packages_ghc742.override {
    ghcPath = ../../../compilers/ghc/7.4.1.nix;
    extension = self : super : {
      cgi                       = self.cgi_3001_1_7_4;
      fgl                       = self.fgl_5_4_2_4;
      GLUT                      = self.GLUT_2_1_2_1;
      haskellSrc                = self.haskellSrc_1_0_1_5;
      html                      = self.html_1_0_1_2;
      HTTP                      = self.HTTP_4000_2_3;
      HUnit                     = self.HUnit_1_2_4_2;
      mtl                       = self.mtl_2_1_1;
      network                   = self.network_2_3_0_13;
      OpenGL                    = self.OpenGL_2_2_3_1;
      parallel                  = self.parallel_3_2_0_2;
      parsec                    = self.parsec_3_1_2;
      QuickCheck                = self.QuickCheck_2_4_2;
      random                    = self.random_1_0_1_1;
      regexBase                 = self.regexBase_0_93_2;
      regexCompat               = self.regexCompat_0_95_1;
      regexPosix                = self.regexPosix_0_95_1;
      stm                       = self.stm_2_3;
      syb                       = self.syb_0_3_6_1;
      text                      = self.text_0_11_2_0;
      transformers              = self.transformers_0_3_0_0;
      xhtml                     = self.xhtml_3000_2_1;
      zlib                      = self.zlib_0_5_3_3;
      cabalInstall              = self.cabalInstall_0_14_0;
      alex                      = self.alex_3_0_1;
      happy                     = self.happy_1_18_9;
    };
  };

  haskellPlatformPackages_2011_4_0_0 = pkgs.haskell.packages_ghc704.override {
    extension = self : super : {
      cgi                       = self.cgi_3001_1_7_4;
      fgl                       = self.fgl_5_4_2_4;
      GLUT                      = self.GLUT_2_1_2_1;
      haskellSrc                = self.haskellSrc_1_0_1_4;
      html                      = self.html_1_0_1_2;
      HUnit                     = self.HUnit_1_2_4_2;
      network                   = self.network_2_3_0_5;
      OpenGL                    = self.OpenGL_2_2_3_0;
      parallel                  = self.parallel_3_1_0_1;
      parsec                    = self.parsec_3_1_1;
      QuickCheck                = self.QuickCheck_2_4_1_1;
      regexBase                 = self.regexBase_0_93_2;
      regexCompat               = self.regexCompat_0_95_1;
      regexPosix                = self.regexPosix_0_95_1;
      stm                       = self.stm_2_2_0_1;
      syb                       = self.syb_0_3_3;
      xhtml                     = self.xhtml_3000_2_0_4;
      zlib                      = self.zlib_0_5_3_1;
      HTTP                      = self.HTTP_4000_1_2;
      deepseq                   = self.deepseq_1_1_0_2;
      text                      = self.text_0_11_1_5;
      transformers              = self.transformers_0_2_2_0;
      mtl                       = self.mtl_2_0_1_0;
      cabalInstall              = self.cabalInstall_0_10_2;
      alex                      = self.alex_2_3_5;
      happy                     = self.happy_1_18_6;
    };
  };

  haskellPlatformPackages_2011_2_0_1 = pkgs.haskell.packages_ghc704.override {
    ghcPath = ../../../compilers/ghc/7.0.3.nix;
    extension = self : super : {
      cgi                       = self.cgi_3001_1_7_4;
      fgl                       = self.fgl_5_4_2_3;
      GLUT                      = self.GLUT_2_1_2_1;
      haskellSrc                = self.haskellSrc_1_0_1_4;
      html                      = self.html_1_0_1_2;
      HUnit                     = self.HUnit_1_2_2_3;
      network                   = self.network_2_3_0_2;
      OpenGL                    = self.OpenGL_2_2_3_0;
      parallel                  = self.parallel_3_1_0_1;
      parsec                    = self.parsec_3_1_1;
      QuickCheck                = self.QuickCheck_2_4_0_1;
      regexBase                 = self.regexBase_0_93_2;
      regexCompat               = self.regexCompat_0_93_1;
      regexPosix                = self.regexPosix_0_94_4;
      stm                       = self.stm_2_2_0_1;
      syb                       = self.syb_0_3;
      xhtml                     = self.xhtml_3000_2_0_1;
      zlib                      = self.zlib_0_5_3_1;
      HTTP                      = self.HTTP_4000_1_1;
      deepseq                   = self.deepseq_1_1_0_2;
      text                      = self.text_0_11_0_6;
      transformers              = self.transformers_0_2_2_0;
      mtl                       = self.mtl_2_0_1_0;
      cabalInstall              = self.cabalInstall_0_10_2;
      alex                      = self.alex_2_3_5;
      happy                     = self.happy_1_18_6;
    };
  };

  haskellPlatformPackages_2011_2_0_0 = pkgs.haskell.packages_ghc704.override {
    ghcPath = ../../../compilers/ghc/7.0.2.nix;
    extension = self : super : {
      cgi                       = self.cgi_3001_1_7_4;
      fgl                       = self.fgl_5_4_2_3;
      GLUT                      = self.GLUT_2_1_2_1;
      haskellSrc                = self.haskellSrc_1_0_1_4;
      html                      = self.html_1_0_1_2;
      HUnit                     = self.HUnit_1_2_2_3;
      network                   = self.network_2_3_0_2;
      OpenGL                    = self.OpenGL_2_2_3_0;
      parallel                  = self.parallel_3_1_0_1;
      parsec                    = self.parsec_3_1_1;
      QuickCheck                = self.QuickCheck_2_4_0_1;
      regexBase                 = self.regexBase_0_93_2;
      regexCompat               = self.regexCompat_0_93_1;
      regexPosix                = self.regexPosix_0_94_4;
      stm                       = self.stm_2_2_0_1;
      syb                       = self.syb_0_3;
      xhtml                     = self.xhtml_3000_2_0_1;
      zlib                      = self.zlib_0_5_3_1;
      HTTP                      = self.HTTP_4000_1_1;
      deepseq                   = self.deepseq_1_1_0_2;
      text                      = self.text_0_11_0_5;
      transformers              = self.transformers_0_2_2_0;
      mtl                       = self.mtl_2_0_1_0;
      cabalInstall              = self.cabalInstall_0_10_2;
      alex                      = self.alex_2_3_5;
      happy                     = self.happy_1_18_6;
    };
  };

  haskellPlatformPackages_2010_2_0_0 = pkgs.haskell.packages_ghc6123.override {
    extension = self : super : {
      cgi                       = self.cgi_3001_1_7_3;
      fgl                       = self.fgl_5_4_2_3;
      GLUT                      = self.GLUT_2_1_2_1;
      haskellSrc                = self.haskellSrc_1_0_1_3;
      html                      = self.html_1_0_1_2;
      HUnit                     = self.HUnit_1_2_2_1;
      mtl                       = self.mtl_1_1_0_2;
      network                   = self.network_2_2_1_7;
      OpenGL                    = self.OpenGL_2_2_3_0;
      parallel                  = self.parallel_2_2_0_1;
      parsec                    = self.parsec_2_1_0_1;
      QuickCheck                = self.QuickCheck_2_1_1_1;
      regexBase                 = self.regexBase_0_93_2;
      regexCompat               = self.regexCompat_0_93_1;
      regexPosix                = self.regexPosix_0_94_2;
      stm                       = self.stm_2_1_2_1;
      xhtml                     = self.xhtml_3000_2_0_1;
      zlib                      = self.zlib_0_5_2_0;
      HTTP                      = self.HTTP_4000_0_9;
      deepseq                   = self.deepseq_1_1_0_0;
      text                      = self.text_0_11_0_5;
      cabalInstall              = self.cabalInstall_0_8_2;
      alex                      = self.alex_2_3_3;
      happy                     = self.happy_1_18_5;
    };
  };

  haskellPlatformPackages_2010_1_0_0 = pkgs.haskell.packages_ghc6123.override {
    extension = self : super : {
      haskellSrc                = self.haskellSrc_1_0_1_3;
      html                      = self.html_1_0_1_2;
      fgl                       = self.fgl_5_4_2_2;
      cabalInstall              = self.cabalInstall_0_8_0;
      GLUT                      = self.GLUT_2_1_2_1;
      OpenGL                    = self.OpenGL_2_2_3_0;
      zlib                      = self.zlib_0_5_2_0;
      alex                      = self.alex_2_3_2;
      cgi                       = self.cgi_3001_1_7_2;
      QuickCheck                = self.QuickCheck_2_1_1_1;
      HTTP                      = self.HTTP_4000_0_9;
      deepseq                   = self.deepseq_1_1_0_0;
      HUnit                     = self.HUnit_1_2_2_1;
      network                   = self.network_2_2_1_7;
      parallel                  = self.parallel_2_2_0_1;
      parsec                    = self.parsec_2_1_0_1;
      regexBase                 = self.regexBase_0_93_1;
      regexCompat               = self.regexCompat_0_92;
      regexPosix                = self.regexPosix_0_94_1;
      stm                       = self.stm_2_1_1_2;
      xhtml                     = self.xhtml_3000_2_0_1;
      happy                     = self.happy_1_18_4;
      # not actually specified, but important to make the whole thing build
      mtl                       = self.mtl_1_1_0_2;
    };
  };

  haskellPlatformPackages_2009_2_0_2 = pkgs.haskell.packages_ghc6104.override {
    extension = self : super : {
      time                      = self.time_1_1_2_4;
      cgi                       = self.cgi_3001_1_7_1;
      editline                  = self.editline_0_2_1_0;
      fgl                       = self.fgl_5_4_2_2;
      GLUT                      = self.GLUT_2_1_1_2;
      haskellSrc                = self.haskellSrc_1_0_1_3;
      html                      = self.html_1_0_1_2;
      HUnit                     = self.HUnit_1_2_0_3;
      network                   = self.network_2_2_1_4;
      OpenGL                    = self.OpenGL_2_2_1_1;
      parallel                  = self.parallel_1_1_0_1;
      parsec                    = self.parsec_2_1_0_1;
      QuickCheck                = self.QuickCheck_1_2_0_0;
      regexBase                 = self.regexBase_0_72_0_2;
      regexCompat               = self.regexCompat_0_71_0_1;
      regexPosix                = self.regexPosix_0_72_0_3;
      stm                       = self.stm_2_1_1_2;
      xhtml                     = self.xhtml_3000_2_0_1;
      zlib                      = self.zlib_0_5_0_0;
      HTTP                      = self.HTTP_4000_0_6;
      cabalInstall              = self.cabalInstall_0_6_2;
      alex                      = self.alex_2_3_1;
      happy                     = self.happy_1_18_4;
      # not actually specified, but important to make the whole thing build
      mtl                       = self.mtl_1_1_0_2;
    };
  };

in
{
  "2013_2_0_0" = haskellPlatformPackages_2013_2_0_0.callPackage ./2013.2.0.0.nix {};

  "2012_4_0_0" = haskellPlatformPackages_2012_4_0_0.callPackage ./2012.4.0.0.nix {};

  "2012_2_0_0" = haskellPlatformPackages_2012_2_0_0.callPackage ./2012.2.0.0.nix {};

  "2011_4_0_0" = haskellPlatformPackages_2011_4_0_0.callPackage ./2011.4.0.0.nix {};

  "2011_2_0_1" = haskellPlatformPackages_2011_2_0_1.callPackage ./2011.2.0.1.nix {};

  "2011_2_0_0" = haskellPlatformPackages_2011_2_0_0.callPackage ./2011.2.0.0.nix {};

  "2010_2_0_0" = haskellPlatformPackages_2010_2_0_0.callPackage ./2010.2.0.0.nix {};

  "2010_1_0_0" = haskellPlatformPackages_2010_1_0_0.callPackage ./2010.1.0.0.nix {};

  "2009_2_0_2" = haskellPlatformPackages_2009_2_0_2.callPackage ./2009.2.0.2.nix {};
}
