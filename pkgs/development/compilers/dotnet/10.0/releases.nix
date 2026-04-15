{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.6";
      hash = "sha512-cQ75/6hc+zGl+uQ8lNNEkC0Oc/3T4mjVpeWJFlXlPlSwDcNU5tVl/fjRlieOLhzMF6cTU9lL72yI1dLEMyDP9Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.6";
      hash = "sha512-5jQimhzuPNV6TE6aj52TaYupFZq4IUTFgQrWIwPzzMnolOaXUr6D4RBLhb3IGi3Uv2BU1k4oQTxZVd4xWDiv5g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.6";
      hash = "sha512-1s5oBp6JvoZqZuDgjni+sYxPlhi0nkCqURE07eJQ9jdw1a1r134Yx7lg6bsSQLijqjnGLI5DPN7lU37uWB4+TQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.6";
      hash = "sha512-xS5ooHpkeKXXZmPXheJuK7Pv+8+xBupMFAgWobcOGCWpw5TSVaDzuM1FEfiaSyHDQt2KKyZix8m0csTBbblRKg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.6";
      hash = "sha512-eunvfUh0wuKo11dAwnisa3udCtguCDsKnY/RhFRy8FC1b5H77n0T+2NpUCgyldOjKZSI+giQiWKdqXE/8dEfdg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.6";
      hash = "sha512-Iv8IFWPnBsNIwA8V554YOAOumiojGwUsu9NSBINNUkFoENjHdwS5wpdAI47mGJWCCDFIM71Zv3jkD57DwqBpJg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.6";
        hash = "sha512-MVWSx6oeaOJ60FoMlsAL8gpkGoSsMg2CcM/o3hsY6CcKbkR3HGHhsw8gIcQlQHXfWTLJwrbkrGlZ97Z6BR5F9Q==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.6";
        hash = "sha512-Xh8ftU1G45mh4t55yIF+inyHrQFXbffYZ/h0QvSjWhs2TIw+WN95wJ+4g8mqUvRu9fuvB17PXNF5e8UPdevtqg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.6";
        hash = "sha512-O9BWotDFn8yOGM/tMckBSyZq9pldL4ObSaOhpX8xPQ22t+PJ4hbEGmCuk5NG+EepBRPBUdLForuDU72Pa2gddw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.6";
        hash = "sha512-8glLSqD3bXhg8RC24eKa8f1z7J2Sz0mibzk8Cz7MLHvwFyZH1BaEdgn4criEN4T72sk76kT0q5qytxnG04drDg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.6";
        hash = "sha512-2Mvrr2NE2jX+sXtOygszYRRrp/RwIlaMO4bbAU2wRuAzd9YBH/WsYai30/6iFbwHcsqTUoVwC7PCtKBYHrvfTw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.6";
        hash = "sha512-W1r+mbgbyu8mIy3sZr6XslDnTTZ8zhizC1oF2ik01kX/0mQGe/p1qiK/AVkPBN5Wk25uCNJECYdUHXBOkS5oaQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.6";
        hash = "sha512-yvAnLNsSoUWLZqxXtcm106ZB7RWWteWyBSo3rMhtB8+7KtdjaEkTogI0d/7SNGUabGJ4Zro/nqpKuEdNlRxIBw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.6";
        hash = "sha512-5EMADmMNPGqm++7UlF+9D3R01a1ANVeBUQC4UhGyfktS2aMYBahNiwnlYMEj/dCWQ9FqJ/gnrmYSFdoGsBaAHQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.6";
        hash = "sha512-Y0eBYjBqz1chbRKgGKdsv1ubAZy1EhYFE5KH5XdsIB0xZ7o0t1ruw1Yph7P84HZzNeGI5k4lv3brVrukZ9K48g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.6";
        hash = "sha512-MUnbdeOpMQCgW+eWwL2PJEMBcgWjuDEa9DM+0xP+pZ+qTaasnLrNJ4xEAe+i9Vq94F+vZ9uA0u0nhmF79cYLJg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.6";
        hash = "sha512-VjfFLidwSMXiecKYR4H4TwzgL1x5+jbwhRrr9PxFBEmwEtP/LWokBN22YLCFWmJiSQZqx0n2gGYMrKE2dOvBng==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.6";
        hash = "sha512-K7aqq/2Pmwc+EvczTxlYqc2cbgfQqf64iskbcZp+Se87tpDGR9sE1hYhZ0F7lPPIQVrPyWr/64SVmBVPsDA7eA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.6";
        hash = "sha512-bNnBKCjlaCUvMGu2rvs3p915quVYtlnI+bMEUldTv2DWS4lx2rYmIDY2gu3GFAUVp22PJwQf0pk0yXkUaswkeA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.6";
        hash = "sha512-lAqZuJ/5tST6KCGeCJnZru7IJymSw8QH7zYKGIvHgwMGygSit3tkPMrbX7EW6ZeEU7CoX/OupMEl6bjGNvK0zg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.6";
        hash = "sha512-6a01f3cOSCrS0zmCB0Ika71eHyluY88m0Hcfv/rXrjoeuFF3v5ceM4fvAURgUrdQQDd5x036dnSvW84Ea7mhjQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.6";
        hash = "sha512-nhZ03840PspgZAWpzvPTOHGMo1R6SuJW00WVWe36U/O8kaLsWYBoha9PFdxqOevDekFIzBUvwl3U3o1Z3PgF6w==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.6";
        hash = "sha512-PmU5/Eyx6f5iY+MZ9bzeaj0UkorTaUXegyXQSQqEwElmDDC7YvRAlb9mbXrV1shZMajM4ai5THJQPOUkCwgUQw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.6";
        hash = "sha512-Yt38xUcp3ZcxUmhEYNN9ETORRJM4kVMK4uBzNJAda7PbJoxquzSaKIkb98xQb4Y12p3QTsY/c61G9PCmxnS7Qw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.6";
        hash = "sha512-/9NPTCMxwyE0X5XwLgoNRTICXXdmUMlt0ZC6yq2fDzqpaTtytlGZJV/slCuQGvUC8SaJZQIUN4cGB7XPHNtmuQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.6";
        hash = "sha512-iDJ/vB/y87Lp8HD50CjQKT/ywcjGh1QON1+Qs99YWW425noDMaGcsa41pPe+nVeVCh+wDOiaBcXoHx8iomkyiw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.6";
        hash = "sha512-qpuImg8ZzYmMudU8AHlCsHKK9cOFO6asf/+rIGHHWCvdIdp+iUq96MLP7dcc3oythKNMll63tal1UYG/+Pio5w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.6";
        hash = "sha512-/sL7qy4PLDDcNhGhSGbz/m2nQHNRKUnAOJMTcjCEzSTZ1yLTbF+OOpCSxGn8vIuAXXAxAzaEpEMW9l67IYvfAg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.6";
        hash = "sha512-+UihxId38Pacatt5hJ4XB15vcBFPiJMy/ihuWCSEn24P37lv3/LjAIsOiQH8c+WRnt15dcPFIpFZlUMMdf6Fjw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.6";
        hash = "sha512-aa3qMrx88zamTl4nOjt6NrOkHAgqCnFAvVy17MBKTFcESs4O5MIUPiqqN9BRrh+cVY46hovq40BiRWJYfHn/wA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.6";
        hash = "sha512-G4/r1CuSzuoDI9LsxlNS4oWsyb/ONvTfIlbluwpZ7y5J1iiSFWvT1j/zYPs48Uxv0AwbNfeyWd+By9yOBnspdQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.6";
        hash = "sha512-ecImFJUtXuQRH0fg3B8Q63JwBjRHLP2DR46VWEeR3Sfm7tGinudqtY/gaZfj9Wslbb6fGbYBFGpkClGgH/Fk+w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.6";
        hash = "sha512-MSFOpfXL6b31I7/+S3BclL179sywe3UA96Aj95AspBm2C0rhhgu21k5wuDGoD33M8KsPAHI99WU3lzBwu1Jw4A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.6";
        hash = "sha512-twaK5Q916666uZcne3sWdYCwl7y7rDi6lyVfcwwp/hQs7RyY3INI1E51KCRzNZ0l3c5uFC6YlT3q3Fsky6FUwA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.6";
        hash = "sha512-+Gbf7MOMfX9ZiRg0oco5WUGS0jVF4ZTSMtFgz3dbyIeRKmJuUGBnRlnz/F4WvUpW4VsHs76XyV5aIy1RLh//Sg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.6";
        hash = "sha512-EOU7zsnqY0o+MkSSPful0E6cevUqCwGAmTlsYoHPMR6AwzB3OLmVvZ1M9yRJtYdhA/B2GqkUH+PJmqVjl6tW8A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.6";
        hash = "sha512-AGsjR/MTP9W9JcjafSIIpo/YYatm0mRSoUYcYuNJTWXrS5lW7JRBRwYM2FHrssWPCewGhGhNmEMtBPII/mZdoQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.6";
        hash = "sha512-Zcr5c0ZpwCsNL6vwDku2u2UlgkEAnEV0sozN990ygPL9zwGbqhrRKyWFGFg7cJdQ2BlsM2Q5LoW02p2ZpbUE1g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.6";
        hash = "sha512-Td1l7j82rcXfcFNVBmnCvuvwBufLsHw9a252dHt5XB8rE8LZJSyH/QRddaXjT2AxpBWJC0QwzoZav9vlzpJTHA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.6";
        hash = "sha512-pDwoxcq38VFWF4+Fi4SMzRsqNYmD4WzhZuGhGz5Mg2RyynioenE/PsK/MReTa5uhLkzkNsaJ51rXujAkgLJNBA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.6";
        hash = "sha512-fPtfAjLbxa1es0q/g0OntHuIa8Xl0X7yZoBzd1Xaf7BcMd2c++FX2XJzSjjOfim5AUvcSfSWrnuxoxXddiJQjw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.6";
        hash = "sha512-McDEjK+6qJX2kbxt1rreDMPSSkwQy3qxh1EhdEsdWqvFdCZlRiaS5t6v44xC/yJrOGiDgSL2XTbQ0aWRrmRAkw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.6";
        hash = "sha512-giy/2l5hNsdfYQ3hu7vtq4syY4zQYxPcR8BNeExKglwyf4DLX3DnJ8Sk9tQgsZHqqGDme1tB2t5z/AQM1hSqCg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.6";
        hash = "sha512-So9GK9T9BkPBmtFIZKE2NU8EvYsjvsRanOs4ueB4C5n3cUReIDveVJMjhyT/33P57/ghSTnFHPUNm9AgP8dkIQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.6";
        hash = "sha512-VjDpiEesPtpCTvMGzYgPcZVhifNckKeiOr3+/kHeagMdyCl5qhs+wTVJPYb5xZzqSHAf8bhy9lzZBX7qgv5yvQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.6";
        hash = "sha512-7PTkVV/BWsI7e3gGEbFOoWfNik6fxvgF/KQBfRw/PMDFDV07b1hCSeuwxgSzjSkI3W+lTCP7a6S6EqS5dkyqsA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.6";
        hash = "sha512-HJDMoUi8E4Y/dGqldBQ1APvHwNw1vGj95xepeSi0/h8gCYK4uTpIWXU/ZEcSNeKOcDQBV9zfbzxqMbm4iN6nvw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.6";
        hash = "sha512-6Cvd/jDu1iitejEqS+xOc5jSjfW4OHDRuVuIZmVjmV2BKx2Qri9iLo6484QZ1+R2DrdfcsVlFpsW47clh3Br1A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.6";
        hash = "sha512-w6a0yXaPHGp4PE8MgE0fEdqnm2qH7iqe6dqaKHs+e3QPcRgZJa0tj5H7p80sqfCyJEREesyQR/zd4tIlZkaUQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.6";
        hash = "sha512-i/xLNwkkQSL8iP4PTuzCn7Y03JDX8XCrniTmCWcMPD8UPI5TLWoKzpZtXi1cSK+ycyQcZmL5pJtTkYmWrKD3mg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.6";
        hash = "sha512-u+sBPLJ91iU0l+DeQ5s6iBjlnlygCmT6KBblAGMn8J524k5k6rvXeY2Jo/YzSpZOz+Y4Ym8xMLdmPThuCKUTsQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.6";
        hash = "sha512-NkLwgpFuWaaodP9DM/aHvoEPNPoEjbBWp5hsXajByz/Z2QXIcR0moUNwJnv+ZSVk4tddO2BgyEhKGrxqw7S05Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.6";
        hash = "sha512-lT51NcUPT5ucBJfRfmTW9gewi41ZldiNz7nyUhemuGtl9LIcUcgkDcQiyQvkI61RYFCmRxf4q1Q+dB3ponv9AA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.6";
        hash = "sha512-sqPvGL7zJGI6eUdHzxWKJNYGhIShTX8aiDV8ttrPm0NQMadAvy0JCEWQpq18SnB50g84/Io5Sc1g5MRjgQxVGA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.6";
        hash = "sha512-j72wa85OWcE2S2XdLHQjjDlET4B/FMCrfejNI8wKjhXEg0hx+REi2uz7GZkjls0skheE2zxfF7As1o1TO+zDXA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.6";
        hash = "sha512-3oG/WjxXnVBlZfa6qCS1IfZfNrz1y1at4Lu2opKPItroTMIsqO+OdEKOxmnPTdaoa77wYrNbNNkeclGoeDqZhw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.6";
        hash = "sha512-S2RslgZXc6MuZ+D3Lm/fJGFuol9ke/b0ooFhdBbdo229nKTkgvWiE9kwbHj1cHl8Hze/i7Wb0yAd9IjozUXEVw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.6";
        hash = "sha512-B1W1PBR6WQN4UkhRwTNvEtlsmrkGOu49Nq/qJiXCVMlZVwwvDZEKm6C+E3PoPbYPCNtPQqtE51Sy+c7DtjX7Ow==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.6";
        hash = "sha512-4I9jfv+drwsjR8fb7omZN+7I9br/7dpjelh++EIo45CpOmbTHqyDZhQidT0LdrJW/c59J7UEOIWF6A56NRO1rQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.6";
        hash = "sha512-2ZaNKsIbhULYFXl8L5enl6uhPo3Wbrcpm8//FCVih6nuLbzX5uSFZhD9hDYfVSy1YO71PHTCQrA+NYLoh+0R2w==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.6";
        hash = "sha512-GkRJpqTrG4m0vnJ3cB8x9Zfu5+lqOnDu+kOtyrSlxY0e+fxwymQSUNDceXYEw+CcT5bnzHSvgz2kxsSg1jy0hw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.6";
        hash = "sha512-PQRtRloq1sdF7bssl6D2tdKTF+qiiWtz9aGBMGJkr5g6HHSCdQeGPKOaK+HslSU9HqKNwLGTWRanhBUL2jr4FA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.6";
        hash = "sha512-t1nQr12txLQwU+Dpe21qyG2CIlhWBW0iCfK1qiyjjlB/XD4ySAPHNy6SdNrS6I8W/FF9P+kEDtvnuUnocW+z0g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.6";
        hash = "sha512-HwghUeLMn6uClRHq4Mw+ATaqmAeREuP7n2TksHPs1K7hHp4/W802wHl9oNOwzKJNMkfuy5TjUxPtSUbUHX5wGA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.6";
        hash = "sha512-5b2W5bJMpJS5j0h4dC0YZoyFDOysCmpV7l0W59C6jfIoVIB08lAlEhwL7wt/YHi8d5A7AX0L1PitkhCgUreqCg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.6";
        hash = "sha512-5BuC87z4VTVqAYSclM0OYEFmKKQK9qX4k/XeIoxarwJIPQRK3G9o/oU0VHaDEoPTVpwCwnzWFPdS1Bn0B/ZOpw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.6";
        hash = "sha512-sHwySUT1UMFBzBIUnA/j9/u9gP8Umlul9gc6qrM7u6toxB3tylMc7yhX9ul5sGRWUPv2IIVfuZkvuSWTN//1ug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.6";
        hash = "sha512-olNum2yYdf+2LblLZ0RktAzcrsgEnNu/X9IvU5ddPqgRshF+uOu6rPxSv7gegdnlN7w3sGwqiJPlQP0mBc6Xew==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.6";
        hash = "sha512-f9oAat7sFvWFt9kOOuLzYjvYiyi3LVNyPzmSWtBAV8dewrqM9llXG3GKGzaMC80OIO9Y25XrbI6hEyFg/15Hyw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.6";
        hash = "sha512-PM66kNEWUm4GwPikbHPL/hjp7RaDrVd6fMBnhV04t4Y36xfiKA+cKE/emPJHfWRd0WKFL8k/c9k8Tw3mqCvg1g==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.6";
        hash = "sha512-bo1NORQPVlxf8O29OGK1JiiEvFLLAcTrFo/w3XS4bni40+JeVbfKk1WD+gHlSy/Gea5YH4tVgG0mZ++0kfVoAg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.6";
        hash = "sha512-MQIZEn8x2fi7UL/ngd9XqSN7rMlTKPlH5umaG7rninMmcoPy/hL866/gRL8BQv9yRC60QtX050hM12JH+gzIzA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.6";
        hash = "sha512-5Oxt114RgC3oNWAs2qnpkqe28xFQq+4YI40fcO+03oaoZW3sHaGystdG5RcE2EqAeVaQ2/g5gaON+bMgc2phtQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.6";
        hash = "sha512-qxeQpjdYIOpqWn9w5Avv3I0v9QJDLgxSKvEkQzNZpnK+KPjeBjyOLNXKiwHkBL8/KoCGLyMmIG1rijxBtYFZsA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.6";
        hash = "sha512-LI37KjRfGiAvG03utxM+Z6b8FEzqd0Oo9MXCGJCPbI8qXmkELw+kYvqhvXFjlf3+oe+SNhll6AuZXL0kpLkHTQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.6";
        hash = "sha512-62zV5HvUEb9wmxwbVzrlo8HJxXJ/gddW/Q8iSuLSRYRzRF0Bmd40q+VZowvB+LbUDKFW0PhQWUOrCWxcqxT6xA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.6";
        hash = "sha512-xRmMqD5dCksz9UYX5xzMNTrOQhEDGSi4avLakJsBzn8vCsbPwah/ixosVHhmKAOyS+eql84U2M5cw4UK3q25QA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.6";
        hash = "sha512-yL9Anp59gXZjC1R3IxbtZINvV+m7QuDxbhUqogQZCZFUhIkyJQYHVGwSKXeNhRZek2moMwak7jUzV9R2lROCNQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.6";
        hash = "sha512-ZgWfYcGFdGN6+4hdE1Z7+k+gox2AvjzfHlDbwSk8x68vrew4XMuOSiN/dqI+L7gq9NiSr40QfL0Is3fDx2ksQw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.6";
        hash = "sha512-ti60jzEk1+MGOXgj19APSePTYQbRdg4+98TMoSy3QWwC/MpiQzk7KgOkff6RH8kPT27DRTmEDepuYaT5q2wh1Q==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.6";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.6";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.6/aspnetcore-runtime-10.0.6-linux-arm.tar.gz";
        hash = "sha512-RvYJLlFWCpY7JgOXEHexcZccLUgdv4p2ACMOjVken/moC1b9fHDhXWwobdYRMVyuZhfnTaGkNTRV06lwyicyVQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.6/aspnetcore-runtime-10.0.6-linux-arm64.tar.gz";
        hash = "sha512-je5OZaSnboM4Z2Ft9QijnC+KcQJpojYeR6y3PQkIDlBAXB2EIGMn/13xJ6nyBkUbDO3xRR1DFE5EDZxONQ6Ulw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.6/aspnetcore-runtime-10.0.6-linux-x64.tar.gz";
        hash = "sha512-ie6xbRlx3AqFR1SjvEzrtjepWciJ9WIWryklgLdvv/AcMp3QkziWt072otS8VrnEu2BRltXAUgykMCdCHRVTZQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.6/aspnetcore-runtime-10.0.6-linux-musl-arm.tar.gz";
        hash = "sha512-VTcABH1CdHOuT9mBJFWpkZBvvQgXTskntNZDtdui8JWOPAy2zsajsNGdNxT4UiWfHpTotcPZb/RbNH7nlAz7ow==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.6/aspnetcore-runtime-10.0.6-linux-musl-arm64.tar.gz";
        hash = "sha512-NzBG9TKQUsV+G7VNVMrXgP76crGw1DWnf3BLSGYhs6cUyRIYaAv4YCIILRiSUv1pdtbizwXuUnmw/q1nogPEgQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.6/aspnetcore-runtime-10.0.6-linux-musl-x64.tar.gz";
        hash = "sha512-hgKej+R6sBCbVTdgJ8GOiWC6Nteg8wCQso2Ganp8QiEPKhcZaGDBCMHwQ7MZwJVtaYggMM4F//aHKFxn7bnjbA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.6/aspnetcore-runtime-10.0.6-osx-arm64.tar.gz";
        hash = "sha512-QM3fKFKBxlCCqpAnVFmLBbBpOwSgZ1rlvnmrE2ACtaaeMfWIDOfkmSU5Bt6+HdTRoYZCLI9nWU5Q1FLr4/YFOw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.6/aspnetcore-runtime-10.0.6-osx-x64.tar.gz";
        hash = "sha512-FIJM4zrPq1ZcJI9byQBK9beATUB67YxF8CXFCZLyD3oojPWB0LXLufQ141sYRBdn8Pg3Erwmeub+ZQu0auHzBA==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.6";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.6/dotnet-runtime-10.0.6-linux-arm.tar.gz";
        hash = "sha512-3W+nV4AoJuX9Z0NaFgIM+rCXXSrRtRbbaQL0IQpN5Rmk6W6cXvLOKAFteF6yGrTUot1hN8sK+JiszRU4BO76PA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.6/dotnet-runtime-10.0.6-linux-arm64.tar.gz";
        hash = "sha512-02ysowTbBpGQuBAm47TrFyIso4us0++Y10uvd+WHTunacL0u180q0XnZZafhgvlSfL0w+vmPbWYRdlUyi8GHtA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.6/dotnet-runtime-10.0.6-linux-x64.tar.gz";
        hash = "sha512-bhHh9BQgPCQxb4VqPmewO4sd/VG1RDcdAoSshvo9rRTZA/dXBNHx8SsLQBdf3ZWz77ZBvDVPEIC2QIGA6qT2jA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.6/dotnet-runtime-10.0.6-linux-musl-arm.tar.gz";
        hash = "sha512-wT1Y8WZNv/1fGOMAIjdXazjZ2a40bDokHCPWJ06l3r9qtgnbvcQT4mG/wFvxWgid6cPC13FFDRMXfxHyMLIvsA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.6/dotnet-runtime-10.0.6-linux-musl-arm64.tar.gz";
        hash = "sha512-GUTvJ5yMzV6gPUJg9IVjg9+wNlvOF4ndfE4lgX2AoJp1OWlF6/MgYS42cYe+LWW5pWEEIkLVB/GQvL11MPss9w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.6/dotnet-runtime-10.0.6-linux-musl-x64.tar.gz";
        hash = "sha512-DLtheFzDRjyAmZ6xvqgW0ZAx6aU6WUDvkqpkYxduTyJ54kJwmnvrMGQNIdTM4HF1kg6DGHdWECjX1DWBKbC2Cw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.6/dotnet-runtime-10.0.6-osx-arm64.tar.gz";
        hash = "sha512-gOfOQJXdpetPQug21jQOG0o0IEDDi5lOGNGRS55AXltMy41jTRXGkSuV3fovocGlKrMGRm0QYjcoiHCYKijkDw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.6/dotnet-runtime-10.0.6-osx-x64.tar.gz";
        hash = "sha512-6QQUDtTb42ezVBuojhKfFtzGFGQoEV3KtASMc4kx/ELNVjqp1jVvMCer0zJj39TF3Bt3TQg3T8XsFu3oDW6N/g==";
      };
    };
  };

  sdk_10_0_2xx = buildNetSdk {
    version = "10.0.202";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.202/dotnet-sdk-10.0.202-linux-arm.tar.gz";
        hash = "sha512-WGLFX/EhJLVyokqhD+Rbi2vL2rQVnhpNTTuoAFwAjWQF5vb+YPW4ZpYY+29GgvECXhChe3tWcRRzH5lrYSugZQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.202/dotnet-sdk-10.0.202-linux-arm64.tar.gz";
        hash = "sha512-Jib6mitQJMCmti9gBbvl1ApOT2ZjDspwXDWLqQAV4tYW+M4UpDQER5kE8i+bEMegP2QrYDLrjt175taI7kVemw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.202/dotnet-sdk-10.0.202-linux-x64.tar.gz";
        hash = "sha512-ZpDG6vGLW4+i0AS0BH5wUqNa/Wx1B0OZoACXKlyg58U22qJPN4sMHaGSbqo4KAE1AvRnsAWobDAVx1z2sS1+1g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.202/dotnet-sdk-10.0.202-linux-musl-arm.tar.gz";
        hash = "sha512-AhfP5r7qHkwPdruGSOUzuQ26OuvU5/qIi2GE81YPTL4DYuGkTe3fgNFMFhhVYFyVmtxUTT+prZNsga38jQrQKQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.202/dotnet-sdk-10.0.202-linux-musl-arm64.tar.gz";
        hash = "sha512-qqB55DbMtFBXlu5MMcUsSKvzDAfvTEmsG61U36PjTpO4E2rH716nv/kRz7KcijT+LLC7xU5OdGt+P5l8iAq1CQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.202/dotnet-sdk-10.0.202-linux-musl-x64.tar.gz";
        hash = "sha512-1yRYmGKYf55XDr1pWJpq5EKk9FIyfAS9PJ0ujdPGNu6MHI3I2b0btEQ1BbdwphTbCtMjHrzBkzKncGOgtIRJsw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.202/dotnet-sdk-10.0.202-osx-arm64.tar.gz";
        hash = "sha512-I63cbAIOK4ASs7e8kgUNbSnjr87zO11yARQW+WQYsiMHXomP5Djv5ZZ+mF7PzSRXKb3Ti/8cVr44nX44xxGIFQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.202/dotnet-sdk-10.0.202-osx-x64.tar.gz";
        hash = "sha512-mdVCP8wewZhK3p7zp+Zq89bPt0hKNrb622IMTQXCtHxphZ+aXoYXOUM3MRzb4t9Ryq09q2dqwCeR8psOkT9CKg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.106";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.106/dotnet-sdk-10.0.106-linux-arm.tar.gz";
        hash = "sha512-oHd0Q5wJH6QswciBO/00LvEqP32f1wYnfwp7JTJDXP3LrDICy7ejIXnRPVPErUx2lFB7wj7xtjPBVu+hP7XMOw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.106/dotnet-sdk-10.0.106-linux-arm64.tar.gz";
        hash = "sha512-u8+cdZiQLIvmS4j+n+68dh+5VZ4LQNDywB/sBO81RwIksiv09iLgfoeaf+fJgsL1qJrMsKOmJHckJaybX0sFhw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.106/dotnet-sdk-10.0.106-linux-x64.tar.gz";
        hash = "sha512-gdqBFFN8pi1FZVlzPd7WHIUYUmIpIbQ9PAbjR6vrm9fMgwGxAO8fCdEO4XMeisZzVrTXTGObFasg3oUCLDgNoA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.106/dotnet-sdk-10.0.106-linux-musl-arm.tar.gz";
        hash = "sha512-6UTj7S66iv7MdscfO4z2C7EZkxW3z3WpIsAUpSr+td2vzNI+4xziP8RE+6byulT0nbwiUvLylcSXnqCX9X44/w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.106/dotnet-sdk-10.0.106-linux-musl-arm64.tar.gz";
        hash = "sha512-rXuMOWOx9dwf5RTGqYDghM/hRi6TF5thh1B7XYEOwjs64qV4aNNsdrDVk/hXTSuzNzmeman4tlCz0v4N8PQhvw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.106/dotnet-sdk-10.0.106-linux-musl-x64.tar.gz";
        hash = "sha512-T3R0HZPNwK4GyuTUHIXrD2d+2GUwd+8bOxWGfW2F7nSChJwKvTMX1+yWAC9tS9W+zGID9OF44rioUD7ymPDd4A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.106/dotnet-sdk-10.0.106-osx-arm64.tar.gz";
        hash = "sha512-F0R5XidzaUbMHUZaBdFjqpu3a4/km0HMpXD4SNmYRAchQ+zu+e+sIQ3gXEn4bt0O92HgETQQg+5GeLlndXyllQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.106/dotnet-sdk-10.0.106-osx-x64.tar.gz";
        hash = "sha512-F7FeD/sWJbhPk0t3ZMQi5XMfjjC58fxoiG/+l3GgwoSIorAaPxrxx45p8LldFTuYRCnq278iQ/C6FhAYQu8eZA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_2xx;
}
