{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.33";
      hash = "sha512-l4Au1RN1mRlq9VZOyEVygQfuBgRwtlliXjQYapMlshSDSeJzfwmQbUG2JQpqJ+L02eTpwiwqGe9wygulIzRXHg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.33";
      hash = "sha512-/NtEGPRoHOl0jUqcDKYg0tv85rMpSqerRe/FXcJVfHlA8a0Cu7+kr4BF//j1KzJFTv8TMH0zMi7KkalSp9cAZA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.33";
      hash = "sha512-sT+TrpGAW5ohk1RNlNS+c7QI33CMS/paqBA++RpBvQhBe5RK4qCeYGVQwIvSjb/v/Rh4E8Qv3T8iyacXeomHGA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.33";
      hash = "sha512-hLPAjBiAXP5XBMKoah5K6iGkGnHyQkXrRy/JoeX/+RrFKNM2BqvjY4MNUhXS7/KA7Z2b/clMrCnTahm2mZ2D2g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.33";
      hash = "sha512-h0YoXYVU+trTSGFGzPuMiVvbprboX867Ylr1OhcqjilxvuPcj+paJs1mAJEm5eFTGL/xgAoxHFPryx3dZJfmHg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.33";
      hash = "sha512-chIW3I7Iyi+GILDI3VAZEM8y6xNex6Nh2jDUrnX3dNYDI7wGbPlnaHS7VzobqXt91yJPstGsdW1V0l5gSci5+A==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.33";
      hash = "sha512-p47khTsLIBcxuNYHfC32UQemdCNeaMgRrVhSKOD2AKyWVpft94TFgRuT/j3LI0HwIHnkxL8uIsQXeZPnOOt5ag==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.33";
      hash = "sha512-vtHOb5B7NHm4HenhxTYi2TP18wvKCSYknMmS1fKTKW8xWPYkzc240HocCrSckaBFIjwkSj1bA5VsfPJF7emexQ==";
    })
  ];

  hostPackages = {
    linux-riscv64 = [ ];
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.33";
        hash = "sha512-JEoqx0eGKFG1bV6txYtR4wJh5HJ3G8XcjunCltGUrEHRDCwnt9bkmPZZjRiiIx4C9gPMd3c653niCWH+nUK6Cg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.33";
        hash = "sha512-e2RWU9+/I6kaSxD0eJB59GxD9uhu87NXJhSHBUJtH9NxDM5YJHzcy8pMQyX34bOJYL1IxLPdvmzZTvBO4LLoyA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.33";
        hash = "sha512-bmW7CFs11Wk9SmKd3oPeLtBjF+0P214Sm3KdBxttUrBUx55dyjYzzMYWk5ECt530VBCtwWc/G2VSdkodGKfC0w==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.33";
        hash = "sha512-oxxlKm277tLRewZxmdCxaxCEMNB/F83AG/bDPucvfuGjZCCEXbXYAagbpdUvdcIpXA8eiRTxVDUnGHbt501cVA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.33";
        hash = "sha512-w4uu16OI3sucx6F5nYRJMamz3U3WzFvuQeFC6Ahq5ky3l2R2YpnBfryPu9MxEwjl2Cmx2XnMYV4JX/RUxsUHXw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.33";
        hash = "sha512-IOuEOfqOZ6bs7sqJC+4XaBs/Ts1457k0oXheQPywClO9SOmciOF1GpAkSx0T+/5hjsmaaVIWNKmbJ9X390N0/A==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.33";
        hash = "sha512-PjMYpxnpQ1cHICxrxVFeJAPRwobxMYnz2uSbrpKMZKAxhuFOy2NB8B84unTpyLRnA4PZkhbFrlx5bRaynBrCZg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.33";
        hash = "sha512-ECPxV6TjjBJQIQYLvux2j9fuzL26O/Tvvu0rJU94Rb2mooc42SFpDEw3133h+ID6SF2C1jAwTV5MTBzYhlA+5Q==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.33";
        hash = "sha512-dGKYYD8rJU5NAQOzR6AYQKoH9KyLStJ0qbzXbHuh515+OEzjXafFq3+n5a6g4wngCOxcG9sJZpnsIsr67Y585g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.33";
        hash = "sha512-vAB7p5ZvGWtHjEl1s17xkxZa8+yGtXc+yiSiyVWHXLzF2lB7p55QKoZdYX4N2qDQSVeE9ziocI/8nGbVAFNaeA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.33";
        hash = "sha512-cFNes6IcxNFRLcNYM5Z4bPMpzvlEpp9t477Bn8cPI2QigCXVK0AgbuAMpsdLrbo8P/dG71q6l0ZVh4M02MXkAQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.33";
        hash = "sha512-MBjtyyjGezi5+51hKo2ceOl5Z1kCxc+3ltMD7almtrxdnSPvkBQ7edr92VUCljiet7SOTj39yNCYQAEj3OB2BA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.33";
        hash = "sha512-KyuC0oi5UAcFOJV1eibi5gDarSXRrSTCgRjAerdvpm/j2gpN+4wUmjisWc7jsWtvzPdia8htiunfHv1dEcJ8RA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.33";
        hash = "sha512-v1oFPhZp+64tDaCA2QPJ82gfb+rZRgKJ2Y9kzSTtqgCg+5pjdURIUEOugJ2cMHFCCbx6IcMbj/fj235iozN18w==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.33";
        hash = "sha512-S2hs6cZR+iJw7li3S9fE4Au2RznFV6Z3YRFhx9+3DXMTQE5ilEX56Zq7VjGnzwZa6SASZBifxyIYwkb/OUwAZQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.33";
        hash = "sha512-4gL/mZ2Z0ryRhYs93I2ceRwx7fN9Q6rjLpDpBDDZ2GWCWFbmfA/CM2lOnnJK4w7hKJl052g2eLfaPC1oE5lFGg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.33";
        hash = "sha512-eF8yZrV2orNaTWp6XCyKL0LHeDMOxtZio8D5pgrA5DCQX2U7CrqWKFkW/F+mLRQ3j+TgHuWhhEm88kAxe1FmtA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.33";
        hash = "sha512-WVmAhjrBqhUsk9waZyvo4r7mwf/wqImbPhy+d3RnTp6hPlNQqFKI4D4HHATmWjkqcVzueIp9q9oMTvwcLvsqfw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.33";
        hash = "sha512-u0jlbL4dxtVkrZNIrrCurXVjsngapE5WNVIVGOn/8v+xVZt7vO2d/kvsJIHi2IJ7KnXOdtzzzLhQtwSpVqk9ag==";
      })
    ];
  };

  targetPackages = {
    linux-riscv64 = [ ];
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.33";
        hash = "sha512-gFiXkHLiL1RC+99clQPlCkZd4MYUzDYukwEF7EoOQa1xTBdJ0qBYbhAHBGZRDOnsgkh30KU/72PhvwU5+kokew==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.33";
        hash = "sha512-HhAK989ylXV07m9gIjGbKEChHdtTteLBF7a5GQM8motqux33LEqgcluW4UWOk2CB3oOrc+2fVxkx4e0HvaIkkA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.33";
        hash = "sha512-IZCELpChRxJdvl/UgCtBwPTONylahZbLqthjeYHjt7hOwWSKEbgNoU0sD1HrkfaGE4nB91FMgCsG+rdbenEt3w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.33";
        hash = "sha512-8lhz45+l7PspkLA6EHhiRn9n7ytctKGyi7bkTV3MRMXgC7R//QhejlJ+AjcH++Yr2Vy7rmXR72uw7aTHRwcWqg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.33";
        hash = "sha512-XAAcLsKjbibmVor+dY1TcM0ft9u+hVZlKov9h1Oq1RDJmrNw1VU/5JnyIRoaGxpnw7AA+DWFx8LvtInZo+RlVQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.33";
        hash = "sha512-HE2M0KQZtxCu78rAH7HEzGNUkWBXqmaVC3X2vmqnNZfB+CEFFKrX2NQtqIo/V/SyBGz+CktPe0TddnRUoYRNIQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.33";
        hash = "sha512-72MUQPYDjdfST3pLm4ETy8AoOS+PXK9nL7Gsu/iBTCh12J2yvp2jtvLPa7fgL/MctQb0GV2TE1oINvdrhRWeiw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.33";
        hash = "sha512-wVn5smVohgiuridGObez3WwSicQQsqjobO/zwYAj2wZkQnlK4WXTrPlkZUbgTZleVCnnpDLAkwOFKGA7VBf6ZA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.33";
        hash = "sha512-X0a/xbHzTrmjrkXkLWMB58jSVqpmzyzO5xslMWQ9WPxBMgKIR0Fhl2Ydd1mqBlgmtfPTUv47GFS3Y5Z5DCL+lg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.33";
        hash = "sha512-PCwuxnYKU5LQInYonBrl4FWHxEqGwOSvgVBnJ/cWWQawgbvNIJRqCN3iU/P5HHPpaA8bGs2yNicFKe1RO1Hp9g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.33";
        hash = "sha512-sWbb6vpLVfSKgPiKzDGMLBVWh4T9iExHSktxwsRk/TvYHf9etdYQzsL//1k48pow3RPrP+poO1w73MY2WqYNHg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.33";
        hash = "sha512-vXCRV5t89syWjrPbh0IjGEIiXAerPcFyEjp5TU78UJqyN8b1bS9OSZULniflue4oYGJDqC4icQt89A5mRVwzkw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.33";
        hash = "sha512-If1IjrcUScipsgFSnQ4cD2jAFJ7kq88pLvkQyZBsM4q5JED3bHpOa7OmqHC1agXyWyLSLIfvnlYYTnzUkuAGeA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.33";
        hash = "sha512-h5bRaOYIPLdxZURFConjrq/T8/l01lbp06IQgqqMeJAPnwffVNWMVU1nt3sd54hGQafsjO0nRpeWydZlwztpCw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.33";
        hash = "sha512-fkZRla8n/1VBuHkpZa0yWyTmZmbRJLyAkSCkmLbf1GwMyjfc11jJ3dmyv0bKxz/q93WO3BkMo/8h2NHVcfqZvQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.33";
        hash = "sha512-jyTASDlWUWyleQOypAa18uE91ijz/N9gtvcF3Bi3D1Dy3dukSnAvNCWCX8p9ck/ZsAEAWB7JWLmQdAcmh71SeA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.33";
        hash = "sha512-KnoyKzoQwuCBY9WNnj/Wsxn+7UlpLabt9/j7REZs0LnxZG5HsX8vqY1jZuEH4byZZhTA1cBLy01IgnFlTRDgrQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.33";
        hash = "sha512-Lmfpn4KWKEoWz6dUXymtwcJqiT5VZ0dpCvGYgySjb17mPjVNfkbXavguOCVPb/+HYVBIHsB0skvzqzW9wvNt8g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.33";
        hash = "sha512-2ctqCMiqxeGnlc4mbFNEzxp+w2svSaYKRIN3U3Vq/C1p6gahM7HGUw6NJBvSdG7ryTPWHUlArAe0PGW922xZug==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.33";
        hash = "sha512-9DR8OMPYv4doqgIbUQaTx5K9m8p4+QnxbQBHPtojW3GaSc6VQ58WfcXmGyJqTLzEm8uNaex6Dq42LIGxoSNi0Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.33";
        hash = "sha512-ROWi+yD2lT7GPuAYZeTJGmLVvzHsY6Th0LXn/MTkKLpIqygrd9RxBeDPxpkrEYFpSVzlaaDbjbIsnknPsgkSlg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.33";
        hash = "sha512-k1MC91PK5wNJ7t/JpHvlz3o19K/pUrqHSoL+t5jLGnth7maUTnk6xjXPEYqYIjpOskTctIWV3gy6JqGFIKKefQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.33";
        hash = "sha512-HqU8QGrxVhbawtnZqdHZK8W86Sqxggwbn5SYbSYhSYheqmInkyLvsYFvo8caNKQbBVluXTSA/eCQXALCwNmP5Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.33";
        hash = "sha512-ikDXjSbRJMUjREOTGc/e97CcSxe0t4hQfvvWrg+OuEhrhZ68oDpXSThbdTzM7zgKji7CpJQ5tYkCIpw/+TBLwA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.33";
        hash = "sha512-PFFGjfmo7yF/fcLmNJzgTmSt9eEqEIcv5YOLsRu2PB/eJTYlFEIAX5uqBkPmrjwmiwEIgeY3Tdt+wS81eOfEaw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.33";
        hash = "sha512-FhrnOdAcz1r1XuBk0gjbEbZP0CuZ/iSpPMFz6WZcA8k1F6Swyg1HF/YlocelW8YBgpEQcs5j8FltDOV34P0QcQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.33";
        hash = "sha512-8YgscvRfGJz4AL7eiR+T77Jmjoccw0ZBm94eyTsgWysin2cjISN8krLxjOoIO8R/gYeRtuHl9ctj1DCy/sRXtA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.33";
        hash = "sha512-jf/WCKojVgd7tybZ4WPXjkDeIYvNRgTXEK2lz0fv+UT35/fay2sY0r/RAacMkEXDnKwAAZT70xS9Hqr1iUXMGg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.33";
        hash = "sha512-sWBPhAqzoEfu8/GXFKLL5mMYyvqsPwtyfUgWe3mCv7eTtbfLk1rkJMdbyPi9/WgbM4hAoeGvfLfwkwQLEG6UJw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.33";
        hash = "sha512-TZbfUkQrFh3Tt2LuSODiC8iYk53NQ6dRgJK0ygprDv/Ug6nC0o2ELAazpbAUn6w58dXPXJbg2TL3A0737a6BGA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.33";
        hash = "sha512-+VzUk1ri66YtzXHa24x3mZLb7LYf8J4cXVH5GXFhYCRr9FSpmg6gZ5vWf06ZSoOGoO0kGxuq9Jj+bc8nyFsy0g==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.33";
        hash = "sha512-Ch8fwTklgR97H1mmbPYWiWV+is8hNJ6iMTK1pWn0CH2x7md8rh1qy6udkE+R7xcJ7BVPaYkuml6OJ0TV/n8Zmg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.33";
        hash = "sha512-kx8AD5O2Dipxrl6zF8lxgTw5imxRd0Arslkjt9UCDOlNdBI8YTkL3dignN+C/rDdHEKn0LGke4biodFQuzVb/w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.33";
        hash = "sha512-hd/agqVigShnrgQqV/lmUD4ccjzuwuK0bnW1eyRMUhHRK+tDXeqTXtg88aC+ns9qneHU0iXOPEXGiiJquCLbNg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.33";
        hash = "sha512-E5jRSHk6a1hBDeW1hfqHBXc6Dxrwwq45V+Cvs3+kaJGj/r7F4PL6fqQXuSsxYJVdgFS+TDGDg8GYljcyVp8kig==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.33";
        hash = "sha512-BDsEGHxLxaw7nDq8fNyauukOEZ9tPTcc3SoMpYgI33DlYP3ocGnMBqXO6pl2KGWYaaIAgPqOwNZ5nrB0JzTm6w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.33";
        hash = "sha512-F2quvit2b71xKS/8tc7hGZLyPecyb9aq+yyy4kfN55KreuUJKb+JqypbbK2W6IC8h4VOq3a6RlRaBvpqLumLOQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.33";
        hash = "sha512-+22YBXMHz2HhpIhOmEi8A19NVmc9gGahUZqRF5I9WCsbvSAuyPHtQXmuCsfHDgv5wcxQ5N62UWvFG2D5apCI/w==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.33";
        hash = "sha512-TOgXs5YzBo0QTHA6dR3i7qV5YZPxB0DJ7TkZD0bFreNeb7JFPOtW3TtPkn5V+XbNlg5wg7vcufGbQAEsLgubiA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.33";
        hash = "sha512-Ni9nBRpG1rZ9fKUUIfV4ep88EW4GhHrJqRqV9QLfAo89czduIFdtPVO7gy8ocx7qDr9kFLylZ4SwpDZq7lf5jA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.33";
        hash = "sha512-PtZ1+nJlVokdwSq8wuEKFZKlla0mmqIO69/Skq75BoK8NhkdYwmTKvVl05bK5+Zyar2MRXd3jYwpIQp12Y0plg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.33";
        hash = "sha512-kUcAyShnaVimsIyii1uaAfzL06oqKa6/KJddP7msEtoGLRbh8CP+UA2uTxpLV0aKwANkkNh8y1Ziu6gIlAeg7Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.33";
        hash = "sha512-0QrUFccioBAynJoVdEdv6z+E93ZgzBHe/b405PaVfpiQN5w898T2Y84c82cz8qWa7D6JfZKxYiTE0evLGY90cA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.33";
        hash = "sha512-UjdteVj3uSfgmAwojHbbjg3f7w9aQ2droqrRpt87P5mcgb3XRb7hFvz3i4AW8VwxBFfvQD+0a1MCUyfGBl+rwA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.33";
        hash = "sha512-kFaqd3v4Qs9H7TAIkfM3xYhsVCOkr308tKyHwvBZoQzeP0SzmJizvCisgZq/6RLA15sdDE5HBM1KwArdLSfXlw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.33";
        hash = "sha512-75LcUYmFSyIn9NFIx+dbGFlBy9Xj6tIANPaFR5owXqtG7wuvHQihH3twRwR3QyEzyBTGJHaLIRP7doL96AVUYQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.33";
        hash = "sha512-l8UatlgZ3cJkRYZYmJwTBT7dQ/erf9cbFpry6XP7IXA9+wNmgGhzzNihlUqIxtd2DTSMJj5cyowtW0fwyG6r4Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.33";
        hash = "sha512-8/8jqecDMCHdpxQwL+ibuKXLvqJxhXXH1dez8w5ggnRE7BwyCa8da9nAA3srOs4XnmH2AO2pWhrWfZfyE2V2cQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.33";
        hash = "sha512-f9wFtPsE/e9pSpuJh5h7/a4XGK1DqLJxcy9++yIy+qcOcnzl7N6l6oNPIGZmDFcYNK6yxvmLL1lSP6NFA5wv+A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.33";
        hash = "sha512-qsXHaUalvn2bjcoIm/ezNJIDurX6qXvRblEdgaM7JRlLXiU1Tz21Aon3VftotZgfHfWcnO4SmCuJpqYoDMqLhw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.33";
        hash = "sha512-KdlyOBmTfXo4L8/VkYl82I1CYwrxd1mGFaEmnMHEN1/ycmsA1yQtgJZegipEZIin/32ejuJrg1JdztGWZEr9yA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.33";
        hash = "sha512-BAc/Uj4W0RrdOR4lzQi9NcbKGnTMlpHfUzEw3HPTV8cO7EKlnCk1A96f6/OxMybilWY/CCpIhhNNZMyk9u5mDQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.33";
        hash = "sha512-Mkc4twkBhZEGPUMsTaGzbw36gnbA2iWLoqTQy0vtUH7v3DuKaPbyrbgoJhhgRmQGd93yKaUDBav+gO0L3DkOGA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.33";
        hash = "sha512-YjGI4+E5mOyNzuBTyohGEoRHnaCT1qKLuGEpgM7XFa5167ggolrhph0UIjj90YJHx7Kpy4c01hnofZQQNxqK/w==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.33";
        hash = "sha512-CQi6LfZtySQ4dE3t0kTwfSbF9hUvtPmUKeSDZTe8mCGuaaFai/Xy6xfniDDvGWpw0gWOJ60dnNqCaPtNdr3TRw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.33";
        hash = "sha512-vsQu/xBJdmrel3uJ+v0/CjR4C278BtTtcoy/oZ4SSRVcUpmw0rLiYrJxcZO2mLKJX1JM6nf9e4UZFNTRuFTNAg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.33";
        hash = "sha512-oM7mEHEMWoEy0nWMWYmziothHbVUM7xy67jZeezrKLpwEI9wwQd6PAorDETVkuvKfJyHBocdew1AQ1MWZm1IRg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.33";
        hash = "sha512-Kzu6hr9KnDGhkH3nWDYioyL5pBMHAIVo6V5EcgbFvwXoyrNajnKLbfJBKAIEXapEs32q/33ESh3diBlQ4yPN/w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.33";
        hash = "sha512-guK7bbCZ2FISrBXtary2f7sYuyoEUvovUCAHC729Z6HPzzSVrylRETKPyvxkgMV7o+M0QbsACZAsQeMvfidmCw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.33";
        hash = "sha512-TUoO/88EqwNnvv0dKHsMSFxA9QJ9KbzlX2s2AE8IRhorxPMJV9ptZ6n5aKj+osJJ/EeOnIUC0l+bNtpbPoT6Zg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.33";
        hash = "sha512-ChsP/ietgybZIdynxLErbMmXrEFoGEivmtRjo470/7YDXv9pmFk1YQv8ZY6+nqJ5OZoAwTo1oN3iyU4d7h4NcA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.33";
        hash = "sha512-P5D6vbj/covJHTWSgDdnMAtQO50S3+amxmo7DTTHnPqh5/bg/3Wk+9uYhfJtF8L/B1gaNdJYuMpHr8/OewaqCQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.33";
        hash = "sha512-liKdcvHBwYbyZkYoVC+QYouEXLJLGf7RVfn2A41ueS0zEjzBDZwZfE7yWOYgQd53NDpyFyMeILexNyYrscsG3Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.33";
        hash = "sha512-ALIQQN1oeZQWU9+SHk5Yc9zjcA9KTUTA6OyWMimEim2RWTsoxUk+YFqjbOCUHMHt7I3BXW/g+glsgqWS168JgQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.33";
        hash = "sha512-FMVxwioECbe2SHp5DN85EL5HC9e76IRDgKju1IiTw53Of7xGZ3eK8MyHm8qPhICQgbRh+JqPsCPGbaj5Ne9OxQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.33";
        hash = "sha512-s4a1ky+NnNCEO1v8MBkMhgNwA8B4cY9bbq8lik+q4waQgHJ++0L55IbA7mSfWETdQVBrHgRkKOnDUpRxGMAigQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.33";
        hash = "sha512-6Nef1OEW1Lw1n+s2rJs28QcFDhehB86vIvEnGuCaWW8aY1pRUVZHxNlNS4jTurVxvmGGcAzX2utgJ+F3bHE9OA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.33";
        hash = "sha512-Oys5oTuuL9jdbL1ijzaOFwjoEOjIoUxOUBoy7df9EURutdjfjH4L0325HN8dyfzh9YxE/9SerDQeSLv2+gaQaA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.33";
        hash = "sha512-qx3JWKzkKTg7M12V7wZ33XFBC4WNEFD83UQlaWRLvjzR93JFtTGXMm4DG3fLKka8Oo5SsVZ22VQLYMjNIyE9lQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.33";
        hash = "sha512-I6kPPL9caRk0HmE7T46DX/kOsUKD9IehbI4v1EPtH+0H6Al9Rjld68Qz85fXlGUcQlGoOIl/MkmIxsd4FjGUBg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.33";
        hash = "sha512-bYAkgv8g2GYhHg2u1GP1t2bFix6iDccWH/twjmjh89Bl+4auwlEhuzx9CFP3ae5EFhAsC7GXclZSuUUrom1/gQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.33";
        hash = "sha512-sK+4Xj/iglM4b1QnXeOzdJlQ3pFNKRJntXfzbryAGcAIzrL4BTicSV9m7C/iPvx+tHOPJzMGsafj1e1q5pfuIA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.33";
        hash = "sha512-2qbTZeNSzhAd1ZLKf+2uvgDHeMUQtwCr3CE/0e/jRntFboFnqJC+TroW4qyAHBD4fbcovbtyQb1UU3j1SVy0ig==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.33";
        hash = "sha512-lauK9wpQzwgl+Jtiqf89St0raLidfDlso898DxtG/y/xFzDBent7Ej3lwCe4HMot9nh/YxfvBfrjOXdeM2aqlg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.33";
        hash = "sha512-ZCNOE517K4hgyII6kyD5ei5F+xQ0NNXoptcXxDivhgG/xlcEqjG8gMi7FVe+CtWKiYxvk24kqsAk6VswioNXwA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.33";
        hash = "sha512-yk89lnQMbMLp/Bp3gb9gTKCNbY0g+UgRE+PfMb4If3DUL0wLk06IhmM/cAhi4+16XSZizDD97V2xlkGE4HNQog==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.33";
        hash = "sha512-RUluuM9fngnWubav493gyFgE2wd/Ll7yeR+KPcD2khNKKWmtuziFziZDRLhVFHxAzi12swp8HOEzcUyyd5IOBA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.33";
        hash = "sha512-Taj85j+4gWH0ol/8WkGMSpeVKdrAak9eAJ/FvydOMCKQZDz1/sl2MLVRF5UDpmYzEjPPVsC9jVxKzeHMO8A+AA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.33";
        hash = "sha512-ca3vf+5DFHpaF92FJygSqzAYOFxMmnrSoKjxlNVjObJ49pK3vHeHpmtF+eVkjooyqMvkw9k1V/mYdhrv3cc1eQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.33";
        hash = "sha512-ESi5PadJnihcUI4Ibm5mD50OtZHiXg3aKuSeH8oA3zGZl6QOnO64SCLloqbd2HOmcZ/emNhwTAFs7Ale2fjYOw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.33";
        hash = "sha512-rzqPO7S4yijjfDOJ1ZzBXOrKz6wmm+HwoqSwbXHd8aYonNdofyrwNOwOVmYdYv7+4QfFHvJhnsCVoFASBn5xaA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.33";
        hash = "sha512-Ak1me1CRkAsXfrhmsAykV/FPa/Vg4dLs9xthOF/3469yMOGAWqno8UTAwriRc52AeM3ySSsQiAabkoZE+5JEuA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.33";
        hash = "sha512-HtFklIJLckP8yj2h/1dcqFtZa+7Uo1/5kBvFu/OtlyKIddRVCsLgFlDffy7GZWR60S4THTrEUokENYyzGzpK9g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.33";
        hash = "sha512-LbwKBHMLzk41e97d7sVc94TKcWmlN2+QTpUFrP7pu5ifu03cwvBnlIdY27bYkzoD7rum/8w2+m6LkTMvi6HY/w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.33";
        hash = "sha512-8QJQyRVh5RADfTIjZKsuEv1mrO0UKjRc41X9z7jXcmuMDeRwOhkqPo1wGXfHwFxdyt+ADcz/36s5OU2qHRoUKw==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.33";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.33";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/8.0.130/dotnet-sdk-8.0.130-linux-riscv64.tar.gz";
        hash = "sha512-Wy9bhKmSiRZNUqxx0+i1hqWOhsDNIOIhwKQYXouDG5LnjrPpd2f236h3lqGWX9a3rZUHTxzAZVEOXvJh7iEAEQ==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.33/aspnetcore-runtime-8.0.33-linux-arm.tar.gz";
        hash = "sha512-9y3Ms8EekCfJOKWBy94H2fVjDDib4wpQ+rN0ErZzjMf8ZxFfluFtObgG+Ll74YLHVxzw/52lMHe2s54qPp4TNQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.33/aspnetcore-runtime-8.0.33-linux-arm64.tar.gz";
        hash = "sha512-050baS950ams36ITg4Ju6dH2BvJGk6T/5JWhCZa8vU8zfQklRNpI3lpU6ubl7kdb0SqzbgRRbpGl1kCSEqiSWw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.33/aspnetcore-runtime-8.0.33-linux-x64.tar.gz";
        hash = "sha512-CON8bNCe3eYBcPP2VTHxtohhD2kvneYhJeL3IXv/oqwTDJ1rSYAyZqwtSRapGid+CVwia4Po6lZdfeQBRCKqbQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.33/aspnetcore-runtime-8.0.33-linux-musl-arm.tar.gz";
        hash = "sha512-cxHIlv0eq9I5HOsO3b9HEWngdclvjCS/8Nq7XPjdvrqkg3gytTRKufuxqxBIUqUXf8khGnfbAT3oKnEUsKMdrA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.33/aspnetcore-runtime-8.0.33-linux-musl-arm64.tar.gz";
        hash = "sha512-a4WytwoKXNDeoTnOeyHJnwjEb8fzI/fCDpj9kjVFxRpT3r0ScpGtRxUviqjfXZWurXwe0XGaxwpSIIaHMwT7WA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.33/aspnetcore-runtime-8.0.33-linux-musl-x64.tar.gz";
        hash = "sha512-tklrrymhnoV2KZ/m4oiOuUBoV7f1JpdBJDXGMHcak9CHHnbjHFanSqjdcoyAR6cihhvvsYMH/kT9v1mh3tPkzg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.33/aspnetcore-runtime-8.0.33-osx-arm64.tar.gz";
        hash = "sha512-VNe9dIfXdV4FuRVgSGZIiC+JzVfSvBb+wd0mkWICsBUoWh9M/TDyxH/xTRoTa4KupUt1djD6CMJUCM1S0sstbQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.33/aspnetcore-runtime-8.0.33-osx-x64.tar.gz";
        hash = "sha512-g6KfQsKXWVkjyw50aR1l0HVKKD6U3GFquLkglCP1Wb40L8U5TnqFbVEmcMYcag2S94IDVZ4Efdh8S6eH5X1WIw==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.33";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/8.0.130/dotnet-sdk-8.0.130-linux-riscv64.tar.gz";
        hash = "sha512-Wy9bhKmSiRZNUqxx0+i1hqWOhsDNIOIhwKQYXouDG5LnjrPpd2f236h3lqGWX9a3rZUHTxzAZVEOXvJh7iEAEQ==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.33/dotnet-runtime-8.0.33-linux-arm.tar.gz";
        hash = "sha512-gqj3jDCPyjH2Uh1HJk0IMUQ+G3SoGqLRzSOu4RJXgNfNIsRG+3tYGTS/XqmJ5Qw8TIW1Jwk3LeiZJEOJBiaxKQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.33/dotnet-runtime-8.0.33-linux-arm64.tar.gz";
        hash = "sha512-qbol6ucvmOJSM64gLW5PtmY7LI2iO82deXyJ6LHQH1HekPGZTccQGl/vVttAHAWvGExeJRqbzlcK3wRMTjrlqQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.33/dotnet-runtime-8.0.33-linux-x64.tar.gz";
        hash = "sha512-sxQDnTN6jFxL5qb5lxKiYYy+teGrfKx6XBy/HJe9NV9dEWuZMqjPxgSseEn3RjiJbroFNIksZRgxGQiroptPew==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.33/dotnet-runtime-8.0.33-linux-musl-arm.tar.gz";
        hash = "sha512-NsXfcryDgyfKXM2Hg7R7nZ48fVyUi7riDKT5oBBhgSLQ3imbahPP38Aslnw8HqTf8caSeZu614PRgWqCyb+Nng==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.33/dotnet-runtime-8.0.33-linux-musl-arm64.tar.gz";
        hash = "sha512-ShnzRNFHgE1iYdZ89ITCFN/fRw/5CXUiuHqPaEsVk/u9PH7kmJk20NjWK0DeuNU3EPlG1Uo0MO1yG+WS+kU8pA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.33/dotnet-runtime-8.0.33-linux-musl-x64.tar.gz";
        hash = "sha512-cNik8SaldFkQK4NyM+A+aONF79rVuOWjf/UAsOXs/PpJ1GXIkKTZdMp99+DTC9Dt4ZdsIe3iOc5wSwxsjZMcRg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.33/dotnet-runtime-8.0.33-osx-arm64.tar.gz";
        hash = "sha512-C+N7ZOofSWUbuqPdCOiUdpGc65i9aznSiINDnBbB2cvMz1zwH2fJEwlenyMjXcYhElpVGm5za+Tr3b8GDrgnWA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.33/dotnet-runtime-8.0.33-osx-x64.tar.gz";
        hash = "sha512-uhd8Z4/OdC+ZH8XphbfiafqiMeRNNWIr4TgAy4scdX/9uD5uEIF8s8SLZPunOjAcLUG5HOf2BE4fZ582oOo7Sw==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.427";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.427/dotnet-sdk-8.0.427-linux-arm.tar.gz";
        hash = "sha512-MO0lz2Zuq6tRVWSqqNnOxf5TRfQlKFBuEyXEIKMwZ2KfQ5wCHAMcrlZ9govhxbhDK1hnv4RpNXXm9u3bQQRizw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.427/dotnet-sdk-8.0.427-linux-arm64.tar.gz";
        hash = "sha512-K4Ud4I6Ukis4LR0nVN8RLNFn9um289FdLP4UP97R1bBdaxlrVFlB0iyX22K7Qm1xpP5uExqS5ILG6hpzN//tqw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.427/dotnet-sdk-8.0.427-linux-x64.tar.gz";
        hash = "sha512-hXJWkvRl9QJLm0KhWaKdn3PoxXrZ6L/h5wKKUF0YAx1okx6Ko/neRBRbCBcN3ol8injhqhjUIZaYtoka9wldOQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.427/dotnet-sdk-8.0.427-linux-musl-arm.tar.gz";
        hash = "sha512-VbDkfaXd3uDyxK3EOmGf5DmEzlA5iu+7bYXSZXzYPZfe+nbqsXQtJGyVrbbZBF5MODG8tQZNOI6M3Ss44LQtCA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.427/dotnet-sdk-8.0.427-linux-musl-arm64.tar.gz";
        hash = "sha512-+52MlbOEt9mHHFReDRgrcYB7DwyxesgidiK3BwPqdLjeo/qmm762zFCg2auV/LIeh17mZuTirk93i02mQ5lRoA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.427/dotnet-sdk-8.0.427-linux-musl-x64.tar.gz";
        hash = "sha512-N6ZAknVoVgk1bAT9eFrFofsvm/YVt6vF+OQPwrQAHznRMenBwwc7qLS2kyM+v9TDaoJ4X4hjfzilj77qZWNHcA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.427/dotnet-sdk-8.0.427-osx-arm64.tar.gz";
        hash = "sha512-eXhrk/JJ0jOxXx1jONR5i9ccgUPyZ8XoTedsnrihBUkg5W6lR4973ft0uVHMWKrKEfvXgM8TQ1C3y3zctCqMjA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.427/dotnet-sdk-8.0.427-osx-x64.tar.gz";
        hash = "sha512-psbQo3CLFeIChfT2Yhlbb9J2498vyRwKOPMGgf+KI9XjIq2oqS6bQQNDRJ6rY10BswpPVa7vb4hGUaVZzOB3Bw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.133";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/8.0.130/dotnet-sdk-8.0.130-linux-riscv64.tar.gz";
        hash = "sha512-Wy9bhKmSiRZNUqxx0+i1hqWOhsDNIOIhwKQYXouDG5LnjrPpd2f236h3lqGWX9a3rZUHTxzAZVEOXvJh7iEAEQ==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.133/dotnet-sdk-8.0.133-linux-arm.tar.gz";
        hash = "sha512-GsePE3w7aXxpg/QuYUrDZXiWOE3FDztLNmHYqw5QUzIQaacK797tydSEtCdFcF11quWkLLPtdoPQ+hz18QpQYg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.133/dotnet-sdk-8.0.133-linux-arm64.tar.gz";
        hash = "sha512-R5zeAooOsBegoUI5AUdt9OnUPJEvA8EDi4lPpMdT2ybXhH18zrsDh/SupiU07/kp96CwVbDtPbCrznCskWJXRg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.133/dotnet-sdk-8.0.133-linux-x64.tar.gz";
        hash = "sha512-Wio0w4jxf/s8Gt/sETQoxwFSdJwjwDB6tl0vF+61YSXw9KL/K7ZsmwRaHUJB6ieSbiI9aZC2zX6imzzt4gtqfA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.133/dotnet-sdk-8.0.133-linux-musl-arm.tar.gz";
        hash = "sha512-yo8iyH+B7pp+94BQEZgkNd66hucQw9vnxX7jevNueXyWSAuxjMt+HFeOwREyQQRhUHwSSRm1WxJRQK/YfXHHmA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.133/dotnet-sdk-8.0.133-linux-musl-arm64.tar.gz";
        hash = "sha512-ZL2Eq/G68fJPCh1BLA9h46xgtO7cUxLoYwzBgiyD0sHBGkCwBt78mtnUwiorObRXtRMupY+4Qtnd5pGIdvBMxw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.133/dotnet-sdk-8.0.133-linux-musl-x64.tar.gz";
        hash = "sha512-ioJYMqLauIi5T3zAWVmZg4XvjuJE3vNijP9i/u5JkCukus0NfCKQY85sZMFq+b/R3PKfem/XspsYKEpU+sJ3RA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.133/dotnet-sdk-8.0.133-osx-arm64.tar.gz";
        hash = "sha512-IXGE/jtLZ80mToi3VgTx90OdVlSc4drXpY18TH1JEGrQ67gqCMIJRZwQg6eq/RADbjRO2nto6THnQLUyRXDMSA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.133/dotnet-sdk-8.0.133-osx-x64.tar.gz";
        hash = "sha512-9b6PR0AZjDBLGZni3frlsFz0GBkIHTIvNgx0S0mK9j9qDhIdgwmIlbmQAPIxLmklsQFbL9ppVtJsQzQakJ6nEQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
