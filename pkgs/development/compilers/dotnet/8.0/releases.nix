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
      version = "8.0.31";
      hash = "sha512-2fPzTtGH1eqTOA3T2AJTTKprm8kNgwpdmuIMDaMPwmvZUdB/kdBMOe7IS74YzWVjhPpHNX2gG5klxG+Fyf//YA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.31";
      hash = "sha512-AcILaZrbx3YV1ThxriNyJziyYeJHbtO0J3jBnBU9gCSzZbwsO9hVXwEIyWZGjQ1rxtJZ4m0rH99CM5w44jUhkQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.31";
      hash = "sha512-/lRLHYI1unTyWFmIbGgvqqiPEKH19Cw63ps5Q+rQd1ZndFpt3h47mpFanCkFh+hO/QkweEZNHEQxlgh0Zme/Jg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.31";
      hash = "sha512-c5Fqn1q2/devINXYtC9eVIR9EUbBKFiiC/+V4bCS3OO5qLzhgXRaRDZVgw7QYz4uWBOIPBGFC3b23xeuZs6o9A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.31";
      hash = "sha512-vPHLg+E0S7fKI0wAXmVP9Ry6NQvDhDV51Ic3+WkwX3s9V5aK8aKREbqI91XugOjJu0EfGFh6e9t9up88fYnkuQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.31";
      hash = "sha512-swEHhPpIp7MZtZu570kkzrAv3JseY7AlVNFL3wU0RI7qj0ikY2955ALbh6QlUe2rFSbngtZ7t0HOjRmPPHPpOQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.31";
      hash = "sha512-7H0BBM+K+VCtlqU36EdCFg3BkWEAJU0ek2rHTDdc1AX0LzSd7XwZrxjz3ruRa/wci2v8V7F1wyMRNPiecQOVjA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.31";
      hash = "sha512-IJZNYlvt7fSK2NBdHV03ethT05+zls4Z3IpfdHCL6NqkZwSp2jwwHUzSmPFMOC//e5XKxoYDPlDNI49pPg6IvQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.31";
        hash = "sha512-Ceu6BfK2dY+BX/gUaTcr2Z1aE5nyOqGDEL+qXVGD8W+sFVX9FDifTIQGksrzZDQZhDMze+050Cz1P3GFXsPCMA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.31";
        hash = "sha512-eZyl+7Lc6iAQMLugc3aoGCHIQHNPhp/z7Y3KjDBVxM2Xrn2oV6lOAcuIsqCZYMl3cLwvPQCTcZR6u0eprk2MZA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.31";
        hash = "sha512-ArhQXpG/KLj2nz189Ep5OdJTVVOWC5CCVYUGhdAz2cPgU2LDVJFwegD743EhwenQNs7OcY3eOexxiT69ZDtDkg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.31";
        hash = "sha512-sVXSUEY4xKRqemHAFL17RZvQvjASKX106kzYi5RUYi8Rc1Gu8LLwc/mfKLAJdmxbIzyek+kf0ERGeuVUNPaCUQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.31";
        hash = "sha512-rZCv7ubU3caGyg6alMc35WT1CECDcX1WaOnsKjRTswHN4kR1eSexWx5b6r8zGw5aGriE1kUYfLZtujKvZpBx3w==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.31";
        hash = "sha512-SV6taap1UKAlJrFXpFOG2IL8PhsjZsAE+VfmQU79szhd0Pv3FOAyVEz8q11yN8irLnXygyovZDUiC+VJ69qKpQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.31";
        hash = "sha512-Q8D5pvVg4wHipirEnHdtG4Sw3KyjwZp2cNsE0AbeOO4FJYe1aBYrveWlUdkswQHVmbU3Y4Srdw0jS0T7nb7NjQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.31";
        hash = "sha512-PsCXJOyLCR56T2nw25bj7retQckU6lZr9aiODj5CH4H5Y+rOWuyEpmxW1I/F/aJCKGkEbs6kQ2wr4kNq5/35bA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.31";
        hash = "sha512-2oJXVljol19ZHZaEF0dnNK/iaV/FmKSyChYvykHjFRxZpHJvU8R7xNVALV36GEeCcx5FO9J/qXUYyvucGRDxtQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.31";
        hash = "sha512-mssD0QbnqWAsnZruWkFQwJW+AGS/Ne1Ee57FANcah7VUgei9Eq1UCBoyEGcWYNMcf08EIZreNVu2gVqO3rTiPg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.31";
        hash = "sha512-iLmipFPaSmkTlFuuXzK9VxZ1R3aL77y1QIJ8h4fII02faWmO1keb6Zul7lFSRVAi9Zh2jFBiezYXQnrJbxWAnA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.31";
        hash = "sha512-aMrNcfjUtvkCDNDLhZf/DgWwlLKZ6dglvVtOWD931H3I+L4bcmnoaz/Y5yDJH+6RnRJV4RWtH0QUjs+DWOrHbg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.31";
        hash = "sha512-fiKe3j7r7m8ByBtUt/vL0HfUwHsYGxnNXmDDW+DgC+UAItw8tKULBQ80fjxV8XC7rrJIBLrFzDCylkrK0GYYdw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.31";
        hash = "sha512-jiWB/N3rZqQfwWDjZlhLHf7GcBpa+SLuUkMnQNENqIMl660L7Cum0uZ4GBIFq5zkmjY7A6j9+W9hy5tvm9uOeQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.31";
        hash = "sha512-QuC606mRrVZrVveGm583mysA+ArLX6y8FvrLpSiSrDibyse/whp/MzdvbWQr7TZkP9SmF/jnmCSeDRWA8R1rig==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.31";
        hash = "sha512-aljDEbmPkDSsxY7NSURKVIOyMVKfcLMDn28Dqn/w84SCybL5qrcFB+nPdMz8irKG5EwHJ0h4Egqx3Cw3rIN8mA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.31";
        hash = "sha512-rIqSSGfQxPFhEdvH53B3RxaFZvr3k8vndLT9ctvk0gzfJIEEEiQKLgg1o0kmkg6KfYoQVLQaXRG9CYyuDFPvzg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.31";
        hash = "sha512-BoAdQ4Jl9AivFEEWM8/iPyGXzB4XFNfPP+AqriI53iW6qeVI/32RGRGP1dYx1eRF3PXoK/3CE+TdtnRZeB3eKA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.31";
        hash = "sha512-4FnWH6jlKdt24kXkakGaZiEixdaozuq1J531eOqa93Z64c6nb43AxdjKB3fh1f3YA4HkC0a+8yJa+CefX9Ayhg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.31";
        hash = "sha512-Tdv7K3os7zltALxHk968UhOVvLr3Ve23HbvpvP0nqqIZracU1/6xA3DsNJ1m/Jg9jP/diPTUZlEtCcKwoanpyg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.31";
        hash = "sha512-J2x8DspTn6MYGN1T1vFrLWaqG6aFJixLxeKrUlPV9FBaIdDAS6eftq8gl3RuQmWoJeEpBN2wYNXQVxnya6WJZw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.31";
        hash = "sha512-on50IDiuNoi9C89xbZdPZ43i0uGA3XOFPWNem7v0bMh0Fl2kK9VsB3SBoDaa3cWHZn0zkRVdEYT6bVMw8K+YLQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.31";
        hash = "sha512-wzSjr4jgKOhD3wBK0lJK5/UoE7oWnLdIdu5oCuybvrAC0ISYvOebu6loePqOA3vhOoVk69RhELG2BSmUQmcXrw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.31";
        hash = "sha512-y7MBdCyOY3cm79/gL14ofP5X2mIuaA9sRX7jfacmOOX+Pfx4N1qxpntyEo/1JUOMdiWZDWPTBWqqMiF4pPfHTA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.31";
        hash = "sha512-7rRnI/bAXw1foT6jzqzEowqXF9kYPj2jFCeLnOICGO4LzhSSh5yFub3c6J5cqGqaebg6FGg4+DKSVkFdbnhRQA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.31";
        hash = "sha512-P/l9zTi2Li8jxPuj6nnrUXUq463RP+W4xUKdBHpJEIcIjStNrGOhyMdzdpmBcDxK6Lo/jpJeBKa4zjc545k2ew==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.31";
        hash = "sha512-sB40FudA3gZ7zDU+H3GrdRP8eW4oo6QXrwGRtL35feamYP8/qDPq/+AEr08qiKjrd5izXiH9ywOfFx86Zp4iKA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.31";
        hash = "sha512-7Gq7oIx+qc9M6Om1fGuJUPb1crlZ6YXx8dKYSG1Ly7WB3UbqV0CnyH7VA1s64Dx00QVHTsOIBWPnBhqub+6eGA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.31";
        hash = "sha512-pkzoJx5uBEsOsSb2hmEmRf1CwME5+Qeut2ZT/Z2jotCGBp1fZsEgP9fe82+QTwHDyPxr3Y5aHvcSDpgd7qILJQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.31";
        hash = "sha512-CECd0hR9BAtAvvLV7fluqpx/TvIu2rcY7LGx6OZ5/ns66n5Tbz5yDSTrKR+C15ExIpz9D/zg4TnZwOqauQm5NQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.31";
        hash = "sha512-BfK9tJN8hOISk5rRIjpGm97pUsC5qkgyd4OiS1wZZSDel87BoIeCN9RvlK7A6gimh9ZfjskxnxPAuda6GSDt+w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.31";
        hash = "sha512-LeAvPQ8Og9J8GnLbLXI8n7zGWDmlBr+rKLAJm7gj/C2tbdaGLF3iRanv0roskHGyfK/2A6RfqRTVKqqf5r6sFw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.31";
        hash = "sha512-Oo0k7LksPOt54XY23kBMeprx2Plney2glU9stXoztfpI6YJnGegwseAy+BBx9BnSwfg5ml4fyB3hD/YzaCnS8g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.31";
        hash = "sha512-SrlxsLqTwuHJdZdLum93wzbsvL/XwJ/BvSNFA6qViyViSYqABnKuzAdARn2CSA1vcqViix34EmAxDK/MpzT7aw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.31";
        hash = "sha512-zNttVOcOSMCvueNhOsfMT98TpXtS7L594wm/FBkbIzMBXaF5HgTfYZSTGzswFvq/TECW4WxAmPxsMhNBGLJIkQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.31";
        hash = "sha512-dJzphqP88n9+LwzDYLKU5x3JdzgPIu47g4WV5eGTd/H6Zfc9mlb1/58azGjUrTX33+SLFtCzGm0fmd+KnliP1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.31";
        hash = "sha512-P9NgqkMqQCETcC7kUUgSWK41ikMTC6fzdn9W3H1QpO83hVP1S+yjoEsoKsZMl5+LmoDlZQV1iMTyAE4Frq9y6Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.31";
        hash = "sha512-x8+6KJjRkEDmhWeBzEA7wRLS0z4Bn4uvsTs8XZ6EcLWCbpHe2ezqc8yj28rLk3AbTaoAIaYeB356x6k9F3Si8g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.31";
        hash = "sha512-kD9/hA7P24J4DzsMCA749ROZt1FBEXP29Tc4C+L6R7ZH6afcdb2ZHgbr+oD3GssMixvVGCmkNzMbsVGOTNXENA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.31";
        hash = "sha512-aA17iwdaMdsBj/K1UguM/clNFWpcj3zfmUvPxDYy1wDGsMSKsrrvlem/JWrXRSSQQ28ryvCyViTYVR2S94+ZvA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.31";
        hash = "sha512-mAJzNiAYBDVUrmwyRVdgsKKlUwOhOBGj4bdR20/tUCVumS/d4CP5J52kmRDIEqBeawAyyqMHID0N610Cu68Ijg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.31";
        hash = "sha512-MA9u3sD+nIgtklIg9XBJHLtMVhVcVE4MEYPZB8FJPDMJXWMA7hHLdMdpQ3LoxKiU30jlEFZAvpqchR6WgR8tTg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.31";
        hash = "sha512-LBCDylZbmxE+Xe8fnZ2n4oMjmXOLt0n9vOFWJPnXCoea/6ZrpaZ8oZ19Mp9aLBlyHrt9GX/RVF3q3RzhLGlO8A==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.31";
        hash = "sha512-q9lywWH8oraqDIya6WUtrqk0RCTVeH8zdRfQ6JUG36saK4k69OqY4GlAV0aBIQ1aPG6lRcdiV1uyfZKRJbuW1Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.31";
        hash = "sha512-b/n5jX6Y+7+2plf6Ok85FOgjM2Wyps3wpKBfyjRrkskXCoUvHbuoS2hwDp9f7VfUAjflJRKtwFBqjBzsUYNgcg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.31";
        hash = "sha512-X8F/awDfdiEfH3pL3ZLTaygAvmR8pAuLZsHL5wgR9WwLeo4pgPOBUoy4EuxYHPOtEU3kIDo6TJ9uValYD5p1wg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.31";
        hash = "sha512-rwAY5Ho6unI8SaMJdWwhecb0tENEU7HDMg2ouievfNjXQsTlqf1yv7Tscit9iztog4Byf38+INOSXcMqz4TkQg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.31";
        hash = "sha512-VPk3cgJgLvvWk5jEHkh6r9Zp+1PwDe/8D8szXyItz6qPOIkU/g1d4qTA0kvuEF83rcmXSYocj05+fp3WvGMa3g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.31";
        hash = "sha512-ro7C5CA/0yqJkwaLObeNHp0q5qQtjDRXI7NGCRqXgIO4WESJXRBjjb7GLvJtwW312OZ4zDWtYY6j9fh0EdJJog==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.31";
        hash = "sha512-6yteCUOQJ4EDoZm1wMttasgqlAC5zKo7R89SBXDpbxwi2w4CHVPAvIjUM7i8Oro0kET1vI8gD7hgixBmOq+GvQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.31";
        hash = "sha512-21l8VW4+ID72R/tjSAsIAjT+o/AFVnL1woJcetB9adG/9y8/wQ9WlKBJ+KLr+Z2ZIXqaJcEZRi7yoTxXJo0T4A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.31";
        hash = "sha512-2Up6xQTmjqTrVou0OAFHOdios9h5Uh5MsfC3TxDhzsyk3SH8NbpFo9llgu11ZNnNvU5LLfGPvycX7FmSqpv72w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.31";
        hash = "sha512-k+CTL2I5p8fE0LbPNjObEj27rL/1/DPAS6MtKHhhUEPi6EnJegvpu6lK5tNeMi2QNba9CuevfqScoiEEXFhosQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.31";
        hash = "sha512-guh2pusWMOrrTRTvcTOPy9zS8LrjGlD5cz6G0vlDKUvss/Hc3/cLKtlPjUsVNlh0jMCXuJKoen49cHy+Vfw4jA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.31";
        hash = "sha512-uvK0WJm4SQYc5zpmxWxRLJxo5oUeK/clLrjgp74tmmS3jrkXN0f0tv07quqejnndPAC9ZxzGxn7WFIVW0z3zzg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.31";
        hash = "sha512-Luu0GuCDNSlRcwZ2KOXmsA0GoBcOk1wkNHWlKFmw8WWxmcBO4k9erOfAWDURtsUk8K5Um/NjZ9JIIL4YP7gv0Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.31";
        hash = "sha512-lA3xhGkn6T1uYxcRXCFhLjzgHMMRhVzFyC4fcrDLFOQUi82XaU5GfYcIZvbimHfeYStNMXiACRFAz9Epy1RnvQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.31";
        hash = "sha512-ZvnC23aP5GA8ggeS32C/aHN07Oxo2OS/rfCyYyS/vu5AVYx8o3Mi30pnla28GFHnBi13OhDLj7gwUKV8cWwaDg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.31";
        hash = "sha512-jhHu0OT8NNZaidFuXBkkwmHFRBZDV+hyJ7f/+YJ9hOsc4djqn8eWIq1IdX5SZhfSB2JBpz/hvBX9lqQT7WBsdg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.31";
        hash = "sha512-oL6MRD0kPnOddXX4uOCdHNT4GW7jLGrE9YaQpKBbRBjesifikMgi9FwrANLC0Xsd5Ag+MROHs9+HDeANlCQ03w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.31";
        hash = "sha512-wrvkkO5rTj+pea+GMbB0xz33MxPXrP/YPFEYEa8/O30gLS71XIm+FrDPWLgAhGd8YuvvDRcDM+SBiALfjXXddA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.31";
        hash = "sha512-HDt1/BjtANh5rR62RGgiQ4R2DrBV5BzKt3+7F0mxC/mI9lOk4NrUUi+8A+cDKwDDETbzSTLqhOhT1DW3GDaZEA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.31";
        hash = "sha512-C+z2YEjvI5Cx/H4fdBgGqNivcNC+sv/65UEah4Hws/bWHAe8OJLYjxEMMk+hBgz/+VGacLA8XGshBP8CBCq/Ng==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.31";
        hash = "sha512-PUCl16+8+1B55HxlEQsEOFrDRnPyIpf5/eSuwi7ZxmE5w+vhsFBe+d/tTDIHN7XI3phQc4kGClNqWixbmrtIbg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.31";
        hash = "sha512-hFD2XaJcQe1N5H8Zqpl2gJMTe6Cl/wrEFvU/K4ygdccWESWoRaABtXxDjLIVuzOXyzqAJ/9ATVpirT3pmwXgQQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.31";
        hash = "sha512-ekZeYPRF4trWaZkh2RgJeu4UC1OcV+Y9qToL8vNi++dzuGKdM+QdkiKMt02AU9mmTtfKAKyDKJWQXyf7vHNSLA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.31";
        hash = "sha512-VhloWsGR8/m6FY8IxyD7cSnuWjrGijEGQNojZsJN0a3r1aipOmIvLf0ricFdo/Wo3pBTcQPu3f6NHur9fZcG9A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.31";
        hash = "sha512-CgZTEIxVCMSSPkUaO2UGOPg+MOsFuMQKb4UGLLQ1tfOm8HTWUGAP5jLWMW6HfHaHbHnPJimH9b8q6fOHsVuLPw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.31";
        hash = "sha512-9qkZyGW3mCaJAMUaKO/n/UgqeD+2o23n0luIZpW0YTeohMEBUmt2lRIo1vNW1OTTHDm/r8jL/i36nr65ba6ouQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.31";
        hash = "sha512-FMRBwjp4zfMC+CdHiXZ+5C1DK2oHCnB82ug84DhDueX3eX91EPU1UT248ZZeIkhZcPUMBLsQzkLlg4HNX/Hy5w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.31";
        hash = "sha512-FNB5NKoPBD8b9GHJhfSUUgqAF7uNTHEHO/ftHJQm4iWPAYWq3ta+vg8cU3PkG+FTPJJw50d6ypTAZ73RL1pc/w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.31";
        hash = "sha512-e3aZHd//hzqDSRNXFSaB2PYKV67zKWuUCp2pOrwyw1yp0V8wncH5qnt+GH8jXflIn6bLktUsd0v6ZqRDKMqo4w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.31";
        hash = "sha512-X6qxRJWnfrrOJ8s+i1wHyOSJGalPeGI1SdwMq4YjYlJiKHeBJHENHcTum2deCijGqf5H+OFMNwVaN6FySPLzXQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.31";
        hash = "sha512-T+uwK5AsaYQjQiE22L01GGDQFFxYlfDh1XQjBRRWH71D51ysCv66f2FB/wtQfNXFd4H0eH3x3AmXSiuXh2PVjw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.31";
        hash = "sha512-VAld7CRMZ3UZ0q5ujzUVaUR9c8lE7zRlriEkAeNlhZWzxSvL2hPDcBv4C1CzUxCqT8j9A9PljvfLuNu8jBW4Zw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.31";
        hash = "sha512-KhnLtIs0PHDbkxz4WZZCaU8oIqDazGCwMGerZ4vyAXCnGVlbClVRGVFiXWEaeirtn2Zzqb67azRaOcchkkxkfA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.31";
        hash = "sha512-6XvmIn8X6BvJtB7UdRbg0jpGDLL/nv2RhS4LgQMkuLFvyqpNbqbfZfWoiKf7PKorRTRxttKfuUkViBrPd1Oxmg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.31";
        hash = "sha512-aGrQCgLNT8k25H3sajkLCwtmAmIS+ecT6BFaDDm9ifKl38Mv51/pd5JyA35YlhPzKLTrSxyG/jswJxJYG2TTFw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.31";
        hash = "sha512-I2w1Ssa+meO/k6S/Q9QfIWkv8ShyIOUQru0YMoIF6XZM58gwkUhEORNpUrElki8bZCxcFJvS+1Nbw4klRttNQQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.31";
        hash = "sha512-qMmzE6trOGvpaKV9dZJIfeLYvSqaiojTsCdmCPqq5IHGQsZnvwkNapYxDXKJYUPaxe0Qzt/dqb/OF1pEk9Tl3g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.31";
        hash = "sha512-uBnV3QwBqLxUHpJOGgX6Ich42nXWJYIKoKL9if45Dxi3lOjaw6wYK3hmax1WW9XECcRdsLWuZxAjfI6boKFIHA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.31";
        hash = "sha512-pahgSNmmBKtj9nbk6OxnRtfnxK16Ig5O/3zAeX6kRhIo6VWkulNNRGnltYNJrEwfJG2ABz0nQJVJM7Anl667Zw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.31";
        hash = "sha512-fAc5oTwyT4aj/7OAx7E4kuovYTE5h/K3gkO/p9HXy7zUwnKyuE+D5lJbNHaRSUWf2fL+qxcZBtVd83BZt25H/Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.31";
        hash = "sha512-6Os2X1xHCn0vmLoM0jfY7dAPZIy68hpb9wzZ5HHHtW7b531d46hBJqlAuw2QB+Jw4yaHUiMeWpx8DntnqtW6eA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.31";
        hash = "sha512-glgUiysu6fPj4oAGgY0bnd0nU04aUWxShpB5VDIAq7fpN+bc3zjMqI1eOhG/HScwNutP/dr+H4yJs9DWtoZXPA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.31";
        hash = "sha512-17PQ5NJnlctEBW9cHvrTkF4qNUu6L24Pa/obXi3nv3lKu0aUlI1PJBn3b4Sr2O01pxMVyLZHPL6/CyIxEyjLdQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.31";
        hash = "sha512-EwPzfa8XT3lBnfPw0QfnJCd9EyKdqmGPQDHhDBgAvO1XGVv9vEkq69ineLbfHHQET/WSWyBIF/SSyK/F00/uow==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.31";
        hash = "sha512-WeeII0U/JTwXCfs9V0kaACda0gq/RooPOxuGNIBvHFCAaiN3Bdq1uvFAc43p053lhLbBlOY8s66N5Pqw9mrZ8Q==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.31";
        hash = "sha512-OciwKe2eIy36mGo5zlZYD8sdlFfNTt59HFcSMozlXR81hfyEGEhXneMV+DDsUxZtyQWaiZXy8LW6fm6hkKwozg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.31";
        hash = "sha512-IPNe2NmXJTyINuH3Iz3duX6iYVItUVMg9pWb5LI9SSKATUv4IdbfGVZ8fe9xwVDSiW+JHKmQaHJAOO9BM8iQZw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.31";
        hash = "sha512-WLIPYktu7EaP95GOnR2l6C+sW6yB0K4GFEPQd6Sq9hWIpeP/RL6z/gMVRxjaCJ4UqqO15QR4FQRsd5nqzqltdw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.31";
        hash = "sha512-aZ2/uJIeDPJ0tBM5YZXNYXaK/FzdbmJG8fwdd8qmFXyC6pk071IhTSqkMFDI9+FNbIX/PxQmowaiWvlAcc/p9g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.31";
        hash = "sha512-mxHsX7/3K7c9l6ck94GMZwv5jvqcejwvtV6qNjH1dfu28L82X9NjDY26h1ei55eIiHw/o0qyffVaYSVuGgJK4w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.31";
        hash = "sha512-GtJqfnZ5joTw7sPNygDDjL2TdyD0Baky7Z1yd3n+KQhGeaYSNoTVxK0X6K3QtrUUx8YpDvFv9e7Z44YI4u1VDQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.31";
        hash = "sha512-LzbB8y+aOY7PAUScvkDH/OBzDX8XCFwyForWzjsmLcXBY+R9NYzKsaSpZ10SkWdTVjFwpsniNxm2inmu7Nbk3g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.31";
        hash = "sha512-xDyMNK7w2iwIVWna+hfwXWrsTyf631dn8/uCMd8Ds1wmrGOlRxe0a1trC8eb8xsJF06+sVOsiqVhfskga76LFA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.31";
        hash = "sha512-mQo9lLnaPgwr5oRJzrEGMd7pOaWiwZKNprkTyW7bGoso9+kOvl/zSP74CD4SNJ+dR+ILRupOQ/yGa1Z9MbcSzA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.31";
        hash = "sha512-aW2nV+1BFhtf0FQkAHOD1aUyUYKQnI4ccUUWk2yTbPqRJ1fdDTklt4t78zWOyvS4PQTT2BnWc35cQm68+2OwyQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.31";
        hash = "sha512-V2okRLo4jb8rDzNBlZ/Wj2wYYmmDLD7Pzy6SNU6LTSRl2XSbqPy6B1dQjZHknAGQf5+1Q5Y1GyVg6bInbYIU/g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.31";
        hash = "sha512-buoFnZhCprnBLvN05K+Nz5IxHDGQojwabYk7GvrwhY8lqox4kkhttonYci97Ia4c++rqcA7Jvs5wT74CVL/l8g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.31";
        hash = "sha512-mM73q37Uad+zGvv8EkDIKgS1XXisLZRt/9Jb9ZEeNRy4/G/fe/zGXXlxOaS5DNXVOPkmbGlmj0wwuAH1n+uzUA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.31";
        hash = "sha512-JuHPuv8e6VhvSWbI3i+Rxw6y1aij+oawm1C00NBU5bm2qoEB0CxKCpkXJC36/WrJPEDFNK5PiX5D1ifAlGjCPg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.31";
        hash = "sha512-JxR01i9Bbi1gSVd48ludQAba49fTXId2OjjCM7C/Ku8kEpdbd2IhSiUrJ7CmwmasbNUZ7+nTfWjDoPfiZZfaNQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.31";
        hash = "sha512-NarRLp49ZTq8Ieo6PqRwgtX5R1RfX7WfT5i9m0T/QWgda/VU47KeJF93W6YUsW+i/E1QHAJZ+EuQLVEQxjgYSQ==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.31";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.31";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.31/aspnetcore-runtime-8.0.31-linux-arm.tar.gz";
        hash = "sha512-hCE876XlCNHyVOp9xlBSBQo7yfgIH16m7KEcX4HdjJH8q3os5du/Wl+fHXKqtT5iNShrAc+tonls2LFR5VA2OA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.31/aspnetcore-runtime-8.0.31-linux-arm64.tar.gz";
        hash = "sha512-pocdAChg2MuSA2DJj2/bT6hHDTQTm4O5AK7VEsQSfn7SIdGdbh2Iuz9R8+U2nmgPXlF+XDUYmTWBKorXdPVcWg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.31/aspnetcore-runtime-8.0.31-linux-x64.tar.gz";
        hash = "sha512-2HDJSNVGCZOYhnJeKdi5wjUnfp1jstd63vzzhWO2aTLEgPG5gPHxg+KyrBwJ/AZnMOoICt8RSO/dZUsVA+aewA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.31/aspnetcore-runtime-8.0.31-linux-musl-arm.tar.gz";
        hash = "sha512-LLhl4HZD+lI/qajURIv36Ksy/iYoPviWQUE2BAPYaGPlRMPsHfRwd/pt5dLiZnxslwN2F/4mZyktZ7S3vtbHEQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.31/aspnetcore-runtime-8.0.31-linux-musl-arm64.tar.gz";
        hash = "sha512-nITHUJEkHq200HKR6k/Bnn3hdRBG3kra2HELr+u4NcKxWjPh9kQSQuUea/NgfEKkThCCXrqj+5OClzgrdzk1AQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.31/aspnetcore-runtime-8.0.31-linux-musl-x64.tar.gz";
        hash = "sha512-yftzHZSkhYhjePztjmThbpmfSWCJHfj+K7/Vht8GIABIuPQkj/TFvdNX7pPc7tTJslUdeONhN/rFYKskuc0Vlg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.31/aspnetcore-runtime-8.0.31-osx-arm64.tar.gz";
        hash = "sha512-hBUQPzGfSAW1tvRHsXiHuUc5fq79gggSBtvkxvXDbMM4psWUWjdzwpKA5yVhK77JNIT9AUszMNMqVWt+TLxL9w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.31/aspnetcore-runtime-8.0.31-osx-x64.tar.gz";
        hash = "sha512-ScS8Q+gJYPDDNMCJE9sPDXWR8wvemjsPw3bn5YYovFb7/U6Uc0Brm/5T2WcF9HPqwRLDqvLdha1NcJklBAuGuw==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.31";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.31/dotnet-runtime-8.0.31-linux-arm.tar.gz";
        hash = "sha512-CpQNMyD0/FDVVUJXvlWw9LmlFKQoVx5CzF2PMqPedjYzALUgFLNvAh2PqqE9u/5YiTlZc7X6i0dqQgNvDD3ppw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.31/dotnet-runtime-8.0.31-linux-arm64.tar.gz";
        hash = "sha512-3cZrZek3fn84Bbp4oOyb6FffuW34ZjSd8r+WMxKTPGY+XbmL2EQ3idz2RXyo+BVARFCUbvh1YhF9Mmw6RCNGbA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.31/dotnet-runtime-8.0.31-linux-x64.tar.gz";
        hash = "sha512-8za97FjVS/UNdKGzjvqC9ykNl2vS7Zi4RevLrELPDYzvUEaE/AiNSwX5hze5lr8zAuUr2cIwBd6ufGB4CyZS+w==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.31/dotnet-runtime-8.0.31-linux-musl-arm.tar.gz";
        hash = "sha512-zu8WTMHk4onB6MPTaaAdr2xA5u9Uk2UztHpJ8ttCY1xPVXNi3DJEnb5HrT+PGESkhmG9q6k/i3AAIPjxJoj2Ow==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.31/dotnet-runtime-8.0.31-linux-musl-arm64.tar.gz";
        hash = "sha512-ssdbRfX9nLMYemZ8zk+1Op72ITJG0T7cwGhj+o3fIwfh0txBQZPL3Q4I+p+hDJWwyf1/Gqtw3YVMOTGCRU7FiA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.31/dotnet-runtime-8.0.31-linux-musl-x64.tar.gz";
        hash = "sha512-gaAZP5KjEgKemJtIY7KU70OJBYBTo4oP/37KHMlhtpzu3scY9qhmbzPS/ZFCmpgq/4T2gqcSZP6zgx4T2iMMdw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.31/dotnet-runtime-8.0.31-osx-arm64.tar.gz";
        hash = "sha512-GWPSqzeY79wrMwNO9X1CUoSaBmojE85ipXTlVtGeXpga/hPJVF621ZQ3hJcj4cg1DxD4BovPpreigVoHJju4sw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.31/dotnet-runtime-8.0.31-osx-x64.tar.gz";
        hash = "sha512-10x0M+4x3SpdZnLvr+6yotQ/qEsZsdQeQSrK3+BKTNQEbN3VHA4QJ98KI/pgZYh+ASOlxlQN4ecxdI0hynW9tg==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.425";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.425/dotnet-sdk-8.0.425-linux-arm.tar.gz";
        hash = "sha512-n6hSQPVIfSqv4YvPRUzOySRTSkVMRhNtyvzYENPkygCeI0rokmYXxP/uSOmL84jvJbvuRXBqxc6JfPEefRTZFA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.425/dotnet-sdk-8.0.425-linux-arm64.tar.gz";
        hash = "sha512-hKTQF9dNeqhC6YFnnRsETmvh81ubKyFAIeMLxAhx0BbSlhHMo3PYUCrVyJDjrTYO5pj5zy16TVqfuhAtiLoxDw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.425/dotnet-sdk-8.0.425-linux-x64.tar.gz";
        hash = "sha512-k0uAYKcZDlkJrR/QeF21QvSHs7v2zdFIJrAglf3Q0DlCmLFjQIXv8wKSj8zDP3waclPpuH31Vfw2/OgZvNLnmA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.425/dotnet-sdk-8.0.425-linux-musl-arm.tar.gz";
        hash = "sha512-kfff6HhYhwlRTWwWjAJYQUtAmwx2JTDcn1lGLiovDNAr7ksUyUNLyvKMCcHJX80WOneCuPgtKfucCrwY/fFnPQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.425/dotnet-sdk-8.0.425-linux-musl-arm64.tar.gz";
        hash = "sha512-wbwT/hLuOyRbEGodjH9jmF31BN3OnRhPK2csPq8lNyak+C+dP+T2DmsKH2VQxcqXXUeBCWn/rqM418luZZtPyg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.425/dotnet-sdk-8.0.425-linux-musl-x64.tar.gz";
        hash = "sha512-bkaa20HcWzdk782foMETVGhabYBIb7Ht1ClbdxGGqoEOvE937TQN5Ugrd9HWo5lS1tmKXMcynL1rPR11ZlOvDw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.425/dotnet-sdk-8.0.425-osx-arm64.tar.gz";
        hash = "sha512-1CFWvnC0iSNkeaQVU2ATqJqf1urKV9VxanAXYS/MZb20WQaJc9fP/W/nEPJ5mvi+6VsgRroDJ2LUffF29cSn1g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.425/dotnet-sdk-8.0.425-osx-x64.tar.gz";
        hash = "sha512-OydVI1iQXxveYA3QMVojBR7xy9BVpQ62TGde4loE5ljC7XNRdxJUNsW+w4382Vj+4zgplhE0gpnNNKm+qLgBHw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.131";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.131/dotnet-sdk-8.0.131-linux-arm.tar.gz";
        hash = "sha512-jjRjQdOJSyB7zA9T5CS3TTdlbnWY4gDpRE+DBeoW/kfWLYBIRECs7i20h/Nc6HbNQ8UPUBBzmr9JqSsp0BaJLQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.131/dotnet-sdk-8.0.131-linux-arm64.tar.gz";
        hash = "sha512-ROJjWPck6gsnuo1LflD7StssPTmNZherp46m4sD6p50cphk6lX1M2NInj9H4Me2ePfSuFozYf4bpP7ul1nvimg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.131/dotnet-sdk-8.0.131-linux-x64.tar.gz";
        hash = "sha512-phgtPxNsUkSF2iSBVrJjAS66cBeaCEkTG1MxVIdw/BSaQjR/eGX9vU+BBXso+mjCOVqw6VSfLIomgxD0iiME6w==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.131/dotnet-sdk-8.0.131-linux-musl-arm.tar.gz";
        hash = "sha512-Gtf0TWrMSx4UX+gXxdcSj0V4QpbySZjfKr0LoBFxkUy2pBbTqknxN1g/ICy9gHeF/pRXNOqJm4GyG+4Kha3oRg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.131/dotnet-sdk-8.0.131-linux-musl-arm64.tar.gz";
        hash = "sha512-qqPkhRZqV3mkHMfsM6A+Mi1Xqu3g3Er+2FDVY3Hp/fBv1Fju9BJmC4KkdzqLYlshOg23ICYjIG1yxqaKT7kAMg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.131/dotnet-sdk-8.0.131-linux-musl-x64.tar.gz";
        hash = "sha512-73TGyCZNHH2chTSlVkd2cLeUAJZ6I8MJ4r4DY2gD23xvjCObXEWWzbpvCR/6w/7ZZonYvPWesKOslie9XpnCZg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.131/dotnet-sdk-8.0.131-osx-arm64.tar.gz";
        hash = "sha512-SUYa1MhX6L3qIDW80kIsrVtxWZofA7zc+e303lQ0gugooY9fDPC8Kehq6JtfI2GPpV5QtLMyff4IdirXNfuc8g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.131/dotnet-sdk-8.0.131-osx-x64.tar.gz";
        hash = "sha512-hwzCOeAu+ZZ0WIRToRnLPtsSlUVOTo4ftUuMMJpHkpcD7W0u/YNL1508ePtwKidQcWIObDhp0N72xtKtpfm4dg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
