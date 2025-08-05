{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.7";
      hash = "sha512-id6IbzqA6pn5TIbYABSCXpPeNwxUGZuMHbMnjeMs+GQIMFFf2Yr5BUy2kigmXoBtgx8RYHDT3PzOrRvcfX908A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.7";
      hash = "sha512-TeNH3NfbaRL2t1vTSwK1nR41if3XBsvxIXl5XDeVBKp9uJ++D9S98KkNEAUAJLyV+6AZGgcDPlDSG5KjiZZ4vg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.7";
      hash = "sha512-spN1zg0NHM482nnpPzXZYJKgxT+A44KLSswXbsTf+bDWdoZpMeBcODz3pNAz2Fg5PIcpR6amQgTy/G0JHoDqrw==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.7";
      hash = "sha512-SiLChOzRKjrQHquCUytslPdSTgzUV8VHIvT7bertBM7BaidvQDfkl+0O7zrdxEUeN8ppHAsV1ZP+l5tPZiHv8w==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.7";
      hash = "sha512-Y1X3qXOXHD22H1IAFk8BRFehz48zEkiZr/xdQ0eop3xVFvkiSitzVGhGTsE5cA3JG1/5lItxqJLozjnf1RsNVw==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.7";
        hash = "sha512-0hSN5Dz16LRR+ddZh7NjEqOEYsj1Ba07/Ouo9HbUrT6/PJ1XtsK1tdpwoJJgrpKrw+n6JyqpaMKpS4f9oNYNhA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.7";
        hash = "sha512-wuO6tQcWJj1GKWXpPhoFvobx99K0xy0C1Z8ZACvHhRuWoN1CKfPzC5vU2w/9zCCbLR9iDWYrcC0VdrduMJ+BOQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.7";
        hash = "sha512-MSJVLRiLk+L3NjJBx5sn8tZVEGCppOapb6Zie8nebplwo1ifRtcIf6BDRVSv8V9wBh3uI38jJOQwhcqLUY2ehw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.7";
        hash = "sha512-aW8mtPF46qa4i+GrHv8OUiPam/x4xYGOUKt/pUPIFz9j9SMrKXgw0mHK/H+j2qHknN4Ozy6OtcTUxpIdxkmw6g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.7";
        hash = "sha512-9Ihz6lNAQ9IyiGNSD9fGMKYv+0NQQqAZVpn/GbHpTRIlC4ULGELRcHerEP29D2r1ugtZPyrtR2s8EAmMA42MdQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.7";
        hash = "sha512-L52p4oNNHR31GlGLgxekjOUM8EL0i1g+X/RRBFvaUdgCy9Uo1RCpsWX3aKaY2Ca93H3aa8wQBsMFCk/3HG9vDQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.7";
        hash = "sha512-F8YKtHc6Z9KRAo1roiwNnqYCIC4OmGQmq/u1dwumD5Rt6dhRBnbzSVh7wl6OKRADLiX9MevObQ1EqY+pArvk6Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.7";
        hash = "sha512-svhK1og7b18+H2+pqPDerMtM+nFNI1MjvOFyfZ6Q66ALxDf2v4/TyTvekJqEFTeqAl1dG3tYTChRk5ftd5QSeQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.7";
        hash = "sha512-99F1DpBPJN1n2CUfgTgI69e1UaEzT16bER1ROa7i04LJbla7Y4PTe81/wNfg8BFBXV8k9LJTErLDFTQcLRNK6g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.7";
        hash = "sha512-FstPcH3XP9bH8nuTpq129w8M8Qt1LdJqhBNnPJJe6fgwMTaAsHzfmlcDQiPsuXkDY0nDMMug/TUrB3e7xRQwrA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.7";
        hash = "sha512-KPYuoUlT2noytN3CQxLSSorNUq0W/6KH8P41j2lXhTW8+EvH34osmFwOKSTZoCSLgZBLgTUhgGS/7sBwqPJgZw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.7";
        hash = "sha512-hu2Ls1ISDdHRgWoNMDFykHxNGNx5AFf/tSniUEd+Y6filNBm+iwzZlP9Wfb9HQ+N0Dtd4awacc9wxjCibkwiqA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.7";
        hash = "sha512-EBmqQ9WVYHtpGaiq4dKlJw1q/RhqKNRu/kTqx0gqyF2KlULEm759WVXvNsTbn5z4rHATmUlvMbKHl6aPGeEGSQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.7";
        hash = "sha512-JeyTs/3XBT11xNgnJJW91++uJ1waJMoAp+FRQ9CyY9TPYscLOUDTe5cKAy/p0l1lbEOVFbqu/YhpjhJ4S7SH8g==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.7";
        hash = "sha512-SY7EUX0XS4zl6TIqcv17AO5xQDPxrz0pRX2Bzn/KboWFObsLNfF4V+1HW4jLbSMsIK97MskDjfaedeNhYy8K0g==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.7";
        hash = "sha512-sTMXmk+7zY66dB2lTSeqbDAUvMW+iUb86MC5Q6ALnAcQfB0BS0Y0sCFAfqDrjb3+3l2NyGtkLdKA6oI379oWrA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.7";
        hash = "sha512-C2yLDWG6qVMh54srzmyNG+w8kl/gU4TPGKkQhtotemLdIaamHyLM8xTW6UQxubC7ygqV73RZ/gip80zGt3zw0Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.7";
        hash = "sha512-9hmu86MCK6T8374cYyl+AbPpgocORRD7kPKlFjMp2vKusZSWvc5QhS3DvPD6Im9cS7wiiXNhN/IxIvMuOuA2yA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.7";
        hash = "sha512-g3WkCqIJocgTL0Ggcci/wRM57+APJh80V8dJtp2dK2ol2lYdR4cH2UcRLY/ePIPwpYZrbM4jbW1Pom3C9AjLEg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.7";
        hash = "sha512-F978bKpKaTVK7yUMWyN99AxsaK6AmkOOkUelyGJLT2MGGNtUyEYoqG6Z9xlm6xMYNGYo5qiSPcFAjZsOXq7Jpw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.7";
        hash = "sha512-jDGelxUC3MZT30iJzCQDgbTcHfnbeDUDnRYtNfQ2czkaRfrQcgfZrPWX34KRuU61KAxpLLYg9heUbmnevM4aIQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.7";
        hash = "sha512-P8KiD0vwj2ocq/3D/a3vxAkqB/FXHuZl1Os+lcqu4f4k3LmBsju2R+WZnsWljWCEfAm6bwjmtyMchPQnzkmVaQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.7";
        hash = "sha512-j3jihG333llTYG6zr9lCKGj7OPHjZE4hc5RHNkWJShJKecFHMnPk9UkFfzgyf6FouM1K4gA/OyZT/wjmDmdf2w==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.7";
        hash = "sha512-vQX6KFVBAeIo4SvLwlGw/MivqU3JC7mxsVLlNRQzX9W+vbDLdDgLrruCebjRqSdgDV9xoLx3hLGc5BZOdtOJ9Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.7";
        hash = "sha512-M6uGdxBqyzODiOmWE7VmnAYR/O76ZSr9sVNRCwYO7HOZYZylw5y51gRvgW1u4hFeIJxvMWGgicsHQ10FeAEKwA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.7";
        hash = "sha512-atws8JTumHepwLA2m3dKlda/m25s+kYW1ROZD+AlpjQ76MWxa1YYRNVw8WC6eaa3VAqXOQdR9ve2jsBMnjKuwA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.7";
        hash = "sha512-nGVfOa47L+KNChpXQN5PQjI6CSBFXvH63+EJPcusBiH+BcddA5VPFNGFj/Kb3VCrXNKKGFJR6A0Xlgp2UtQhtg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.7";
        hash = "sha512-qkZemav26phWQKiDIGhQjEmNYefeSJCUOHIF/eHiaDnRm2ZmE1zn0Gwiva1DtDScDgDpTMAk2LzRQIOUDwjbSQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.7";
        hash = "sha512-lWz1s0VgvrE2DiDEoWzZALdICtr8+heyyGjut4tnmiclmQq6OooNIj272xxqUTd/fXbMm4SnroE34hUUhkiDHQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.7";
        hash = "sha512-nR++CrvFiYs9LGxdTeRR9kVO4tLPV4hXQJuCPEywji0ikT0H71z3i/ZNhCLHOoFseddfb+x8wh0o346H49/Wdg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.7";
        hash = "sha512-FrNN5JnBUVIrEjEggGLyKsQBhPmUUSHXtlSGo1A5YuAwNUtepbTbwLMCcrEfNJgNQ38+L8naAGu1ZqKtcRZt+g==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.7";
        hash = "sha512-ljwTM1F5KPl0wWaDks91B4+UHaSrPE9G6/U3vqQKspYXjd7D4cI/xBhnIrQrae5ntPAXHwk03Rt0VsbkIP41wA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.7";
        hash = "sha512-wUkyIvfd0uKKSulkzfOTV1ACj9xroqDhAU39Ufz2ZWLoTsjsm1O3+O7KtqEwsJ7pUdy+am9TnIN5pG0hfsFepQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.7";
        hash = "sha512-HoPuExDtKhtkoJGwq+B6mDzTKtjKgrwIij0u9954TfjZyDDwJozmEnFgtoZZ4ltTH0sguKL1JSN7GFYFkQq3BQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.7";
        hash = "sha512-3qlad7bv/DSNzxH/mgvwM//MX4fA1OQmGjyBM6eujEm/K387JQ4OUgtpXHsu8jHvRARCuFB/qNacxbzvYInh4g==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.7";
        hash = "sha512-sl8QufxXNfWIxOjZQtFJJG+5zRWZtxQc0CMOtVF5SURkZLz2Hy9KwF6bz2tlljohK/Akf0udaeYK2XhnHIKiug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.7";
        hash = "sha512-8TsHIOl31DLvkBgj8mHbjP6eSK5wpIGygkdSrBqUJbs+k6MIQrblw5Q6HwMsS8LcRtxvZ4PtoEBubvie/dGSfg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.7";
        hash = "sha512-SXg/5ySrWhQuauFbw09ydh6uJadEAWSfOVDwdEb4Tbd+DkCkjk/bjGn0ALBcM8iEjLbbRMvPOd536pS07fQnWg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.7";
        hash = "sha512-5wYYJd1dr4n/CF/EOHVq4LT2KlEojcl5IWSxa0y4/fdO/1SEKOEPDBKqnR9kiPbNKTB4RRFehQr/kkaY6bCwsQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.7";
        hash = "sha512-zTbTJ3M1BSPPTHkk4KHZJyrK6DhpMUiryHBZ1AYcRlLYCK6ZIpAjv4izhMQHAxMIqz6ovLZVuvc7vU8aKG9qrA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.7";
        hash = "sha512-ci5Uyc/L/+JSEsM6XtuY2W/94KWhAU6K/txAf7FXoups3/kLRQfSSTeSTZ3W6WbUuI2w40Xl0YYOHTo4lTSDJQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.7";
        hash = "sha512-/RSgn8w2zG9pJOQx3qtyce5zvFHxGc3TV3BOTCa9IDM0U33rbNiLg3GEEaodvAuiXkY3jsnDd4HT5ZOHnfboAg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.7";
        hash = "sha512-6vAs0KI14hm+AnP9gBoykxOadgp456o62SJ+o6yFDVqxn+nWb7t4Mra9oLi6YWH69m8mVQN6x0QCusDwdtgKuQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.7";
        hash = "sha512-vKDr+mIfrFC4pGBS7xsN4kqa6YMXezozSfeWIgi9NUzI1tlrRIZrwEla6eIuU/tUzZrrE67bju4R3BnrFSTtwA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.7";
        hash = "sha512-oYJlCtnHBn3dWqOgyE1E4ng+lXJRPzWNYsf+lj00bCLFkjaTLBmG35hMlkZ1ZmZDPBU4VvOuHDyVx3/QLJVheQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.7";
        hash = "sha512-34Y4PO3TmpEaBf7DOQUlckzuJb6G7s3xubcJP3xPrwbLsVstOL6SGKBofWqjyygH3i4VgLYc3bqxoYDryXX2mw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.7";
        hash = "sha512-RPzpHiUrXTqW/hLeUqZDA9AFSkVseZmvWY0wwjD5GGKsTRzQS0yT42PIVqsHbEN/nHRRKWyvTN7tokyYz+MiRQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.7";
        hash = "sha512-GOs5KT4SIzSpfe0WPbFVhnA8+klHq8FbfDeDUTvbhSIClPLEfwheeaM+HuQpZTzxpOaMTWcmrawm33ia3NZyMg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.7";
        hash = "sha512-4oU3yJfh3HRrvRrCC2QU5wwhqiLc1Zl6Py4cmBVFgNdHOTk38/gt43tWiRBAL+xNr0mX0cltGPMirFdtFZt1wg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.7";
        hash = "sha512-cWumHZc5W8yX5c00U3t4WUymi16KojHUMgSkla5NvzuVPmDpopVKsiRB3j+iQtwA14apPr9fe11srPVVMH4WEw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.7";
        hash = "sha512-BODpAvApSDrrndr/6MIR52Sztu7iXCUt4Tn8ex3ZqDMsWgoiCXe70WT0loozMuU+ZnzsXyJf8m2JSlZ5NMsK+Q==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.7";
        hash = "sha512-nn5X84wpzbMfJ1Vx8fgZdL7cq4d2KxWK3M9GBH4LggzYMnK79YDfoxHl+YLTK5EfqgxFfxunzZdNrpUBDP6F6A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.7";
        hash = "sha512-i6qupvYxI42nWLBGcj6Qe6oMPl1uk+9ANDTPz4x29O3/VEeUw7pJZar5dExUcc41cfgA30UHTkyzZ43umrFirQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.7";
        hash = "sha512-i6rCnWy2wF4dseZ6IQcmBPs/A2rj8Yaji1UilfXyOtRnP3uQazDEC7Pd1JJeqzCTNRBgfvXw3r8IHXTxt107tA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.7";
        hash = "sha512-sJgDF8XETA5JhPSvt3/DOIx9SSTuaG14oKcVpoJX4Yg8pPQJ85IqESoo3VSRR7HQWN/e5Nt6ySu7/jnfXC0szw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.7";
        hash = "sha512-7p8ELP0eWRjIb7/djqopJYoLoQstaBZFh7vDB91ikkXXlCxyHr14h0CygLkcUELTMvSS0jnAQ+icnYy5NBA0SA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.7";
        hash = "sha512-Yk+dlmzAg05RUkf3C4eUuEwpk+QFSR8lFpIe5EUT9owyCqCYBa2NrkqeRP2XoIPzbqhNIZqB6ChSbpg0wbPMlg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.7";
        hash = "sha512-+oZ4sarYCA5fqawFE/9JFJtNnERKCMRY4SBNI6FVKtLomoOKbu5LxdxcV4SWYBqfXg08fWJEZX8qHr/Mmd/nHQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.7";
        hash = "sha512-ozFg9cjKG8pN56wrFPV+m0wbVyK+cOutTo8LrIVYeL3epXnahBIa6em7POXvJF2FRmTRjD85ASH8xIrVMc7z6w==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.7";
        hash = "sha512-vgQaQhPWngepjw+y9qhNx9b/QDK1YmSlYzjO8WUGfYDPnUn40gLUzMKlPUAAMTPBIt3clULPLy5K6c6w3bvQxg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.7";
        hash = "sha512-ec2/bdKdUMyYC93cIJ6sqAG5yqdjJ1ikRwy7U12B77HrWMBUOI3UeHRmgcBNw775fYZ8Ut1P15WyaZmCJMW+fQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.7";
        hash = "sha512-yebdLREVWLaayNNfyAu1rffiP4GIpa+Tyz7dhGIF1AlYPWdFHGldYz1eYepzWqqiAXWWgEINQaLD8yaPgRLnSQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.7";
        hash = "sha512-QAJEJd7C4MErPoK6kjzmL7aTiRYSDXRhl3WwDyGzIEav5Me7jDo1OWAENnRL2jw/tB4FAl0k8ADclshPyZRrPw==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.7";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.7";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.7/aspnetcore-runtime-9.0.7-linux-arm.tar.gz";
        hash = "sha512-dMQjUb5A3W8gZWzC9AUz1fRddZM4/EnNvWnYP7TPTkFX3Ek8CAg8SEdES8RiidAz+TyXgHL53nK+56VBJRq6DA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.7/aspnetcore-runtime-9.0.7-linux-arm64.tar.gz";
        hash = "sha512-ebKN8rxSLUe9DqP4tKqkRxAvkgGdA4ZwdD+7weazHdIGSZ/238LTFiPe22Sp4sojYIx+pyJfHwcXRd5yyfgb9A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.7/aspnetcore-runtime-9.0.7-linux-x64.tar.gz";
        hash = "sha512-sXXU0FePn11zXVne8/REWUYu82tL0H2coO2YU79C2Qx7rOGV/yZKnc9t1NbUUshwWQhRRiaPzjVA7Vjq85Yp6w==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.7/aspnetcore-runtime-9.0.7-linux-musl-arm.tar.gz";
        hash = "sha512-NJd8TzThH1Kr3A5I8E3JWrDRvf1kHdQKTFOQwJDSQuxF7VCvsXYTn87WpaU0ayU0X9+r/x6kOLhZS1JpLxSjrQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.7/aspnetcore-runtime-9.0.7-linux-musl-arm64.tar.gz";
        hash = "sha512-1La1Q5lX9q0xwfiT4+dbToy7Py8dmn+iGukimuZSX8+Y1kO+pMuOeNscUJ49t1t4axI5/S3vIyjplUGisE5XqQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.7/aspnetcore-runtime-9.0.7-linux-musl-x64.tar.gz";
        hash = "sha512-rH/FG4C8uSwoIlIIOEksyQjAjQYBFILbOHdtaqxEIASvEKULrOJeLdmGxDC2HKzcGIyqHnJ8WCHO7maaC8sOlQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.7/aspnetcore-runtime-9.0.7-osx-arm64.tar.gz";
        hash = "sha512-A2Zf9tvfeAW/3rSrm51R8a4fqG5cyKQtPvqPiNFAK+J9Z9F4ihplnMQnrzQX2P1XLg2YUcBNSyzDdOJoKxIgOQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.7/aspnetcore-runtime-9.0.7-osx-x64.tar.gz";
        hash = "sha512-aHivNpxydhhA7fLc1m1Yz0zdvKYYyfvXI6bW04Gc+sYVCo1yyZ93ESm1TC/z5v8lgFyI5w5d7zAeJChFi370Rg==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.7";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.7/dotnet-runtime-9.0.7-linux-arm.tar.gz";
        hash = "sha512-hdyrtE15/rPwIuZXM7XDsUQWn/y6uWVFgLp6HvvxRY2qkxY5Wm29nMHaw5s066OSnmOhzshPtuVmrREBH63SNA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.7/dotnet-runtime-9.0.7-linux-arm64.tar.gz";
        hash = "sha512-5c/znYwk0eEUEG6lFWPwxkBUgmiJjoNJow1D8G0ix3WV4Gcl4oBzeT3QI7YSrxFYEjRZBuJszix4jwavYT1CUg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.7/dotnet-runtime-9.0.7-linux-x64.tar.gz";
        hash = "sha512-4nO1kq6eHHXpHOO+b08tIxQydpABQeKcZz1GSQEY0BFfbRlormz+1ZjKMA/oibog+gYHh+u1QDCEM1gKPGxc2A==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.7/dotnet-runtime-9.0.7-linux-musl-arm.tar.gz";
        hash = "sha512-/LZMWeR3TNJw2Fbn4FalAjVnyEBI8BJUBGt3ZLanCNWCxK1Uj7XSMexLCzZp6+nOatJNbnrGlRtQtJAHuOuuoQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.7/dotnet-runtime-9.0.7-linux-musl-arm64.tar.gz";
        hash = "sha512-9cJCVscL9qQS8iEY6EEp74EKY3hxWeNP4MjSH7vB++0jqBa6lXxlNUbowhUr7KKmpEGTlJwOh9a2pkUdr/s77g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.7/dotnet-runtime-9.0.7-linux-musl-x64.tar.gz";
        hash = "sha512-B0CcgI2pzRmmTlJeYSm8P43k7zKzCHAel6ixQweB7bP4Y7Ds6a+tBIhyce4zIXEA9Rn5bYn+2UIAsGESrPrESg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.7/dotnet-runtime-9.0.7-osx-arm64.tar.gz";
        hash = "sha512-DesjrHFNrWm/fQxn5CUyVtCEWIG4BcyLnG8gUSg9X5u7AA02MFhSPc5Mc2HCtGABaoZbbWuqWEPJJjWR1TnrIA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.7/dotnet-runtime-9.0.7-osx-x64.tar.gz";
        hash = "sha512-cOtHKrJPOKam6TBmHgmsZjXdoM8FSJkEDCXPMzLyTxy7PuwZ4c/PIhS0ZtAA9t3H1JRIpsYQbDtw/Qv3Bj9ubQ==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.303";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.303/dotnet-sdk-9.0.303-linux-arm.tar.gz";
        hash = "sha512-bSXP+PZ+aK+YODUi+2IoW44Pg1qodLkdYdW8NbkEy08b1mut9U2y4RvS9y+32VQbkA4kOFimljfhcuFUfVzWaw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.303/dotnet-sdk-9.0.303-linux-arm64.tar.gz";
        hash = "sha512-glczgoLlrZ7IUw5rG3Cl4jXZxKubm+bQVI9hzbClXnFanXZrVSA+4BA24grpvU50q6v6GnyU1F6JsvMU6Q6Zmw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.303/dotnet-sdk-9.0.303-linux-x64.tar.gz";
        hash = "sha512-4RUYwYSrT4C11kEey8o+B+JEoZDpSeUe9z02xSFCDwYQeYeUetqSRhikS5FCyqCXvQNlnZcySfRjql5YQX6/3A==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.303/dotnet-sdk-9.0.303-linux-musl-arm.tar.gz";
        hash = "sha512-Gn3x2Y+NaGNpvhaJPAK39eF7ZHhcS7PVVy8jBH2cfCUrp8GmcSAT/+J0459gcHobDi6gDwdpGXbSecgJkji9vw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.303/dotnet-sdk-9.0.303-linux-musl-arm64.tar.gz";
        hash = "sha512-P0uR41oG2VxzfABnPf8pZYTXsz7pEc4zRBNiSMZfhBWBvjkif9Q6AOPANt3zpVPPAfM7Lpc64q9XibxuUEVY8Q==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.303/dotnet-sdk-9.0.303-linux-musl-x64.tar.gz";
        hash = "sha512-320qBD5LMb54ykNgcnoebHEkPUDK/Pg8vEVOtJBMuDiHGtzr4hgXiFQK42seCineuiljh2F90jxKvZOvy3AMDQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.303/dotnet-sdk-9.0.303-osx-arm64.tar.gz";
        hash = "sha512-QQmZkH1gksUhVa/FnDvKwUmBGFHbcxj2/iFeN7N3rBsxbLtZW7IctSZ5HzltpM1Dnkstt21FqCW1fML0cpouLg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.303/dotnet-sdk-9.0.303-osx-x64.tar.gz";
        hash = "sha512-Awl5B4eA87sII2M/DdoyT71Rm84VP95tQbZvLsU/szgyilAc2eOgQl5eczxDCisZffT99uThQWbyS6sLXDfQsA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.108";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.108/dotnet-sdk-9.0.108-linux-arm.tar.gz";
        hash = "sha512-FliKnG0DCOC2kqy4VHZMQvGuldzdpDebRKLZPIlwxcl0W0b7QITuwpYeknqloxI7fdO1RtAP14epsGza6/mG/w==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.108/dotnet-sdk-9.0.108-linux-arm64.tar.gz";
        hash = "sha512-laP4pmKWsjrs2GyiluK9FHzzluL2p7bGvnlbcN8kEdYWPfFeKKa7JiSOILYZwXlN3Fux39Lwp9Xh5YqdLUU5gg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.108/dotnet-sdk-9.0.108-linux-x64.tar.gz";
        hash = "sha512-jC2YjpmLkGxxaEy+muycvytlyzHtjD6xWm5l+WGwMfrroy1xmX9Q1W4E5vAIH4YEgHItwWk8awFVQ+thrNtYdg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.108/dotnet-sdk-9.0.108-linux-musl-arm.tar.gz";
        hash = "sha512-Qa5oViep0n/EsZom8OdgEVOEkDq7LjkZxPgCe6PnWotANLLpl1Zfd5nq4ZOFED/aHhMbI8F2oWBXiLvL31/BEQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.108/dotnet-sdk-9.0.108-linux-musl-arm64.tar.gz";
        hash = "sha512-L8eGZ6/7dXpwcXWjsMVXmF4s6TCnUD9KqE8gsILZiGo1oPDfVLoZAteLAtYY+3yImdxOqZaY6tQ8fMVlz1X/2A==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.108/dotnet-sdk-9.0.108-linux-musl-x64.tar.gz";
        hash = "sha512-CmB51ISh0QT2+vBf7OJTUOnBi0lNy6M4aNkpTHwubJNuehnogsZadXezZ4xCHkDftpHqlQSmfWWqjVuJK5cxjA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.108/dotnet-sdk-9.0.108-osx-arm64.tar.gz";
        hash = "sha512-EeZLhqfvjyPAsLdoE1f//OjirZo42SgDeKYbnxUlssN1QTcM1VmL3iu8EkUftbnzklHF7LIORgbBNDSYu+MHEA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.108/dotnet-sdk-9.0.108-osx-x64.tar.gz";
        hash = "sha512-knxa6JTbG9pShc3eoC9zzVWtPuSfE0iqFeMoiWOxymlQEvzlH8f6DCV0Tvty+c8Rzc9nqBzZ4EAI+N3gg7zfYg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
