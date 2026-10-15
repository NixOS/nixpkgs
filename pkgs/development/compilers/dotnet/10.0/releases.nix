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
      version = "10.0.13";
      hash = "sha512-GIIEHQIsQohxLcoFf/OJglifzh33VDyJXRR8V5q1HupJhmV6GkIvWbZgoV97nZGw07UYaDjgsDLqYQ2lFkyM5A==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.13";
      hash = "sha512-/ds8Tnf03b23EVRv37C6iOXVleTn8zpNVYeNayDEfUQ2WAyoaulbbDYT24nCwSPXXqu9dGXR06gbISt329JOjA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.13";
      hash = "sha512-82kRjGFuI7oE0u1WWeAhku2t7mRcBQSVPFU1jVTlC0S+wBtfKVcnP5ylUnELTLDYqZcdjYu9IwVXfkvL6cZAVw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.13";
      hash = "sha512-VE8mNXuWljFOtfjF58uHz+56F2sC7ahlco8H9/Xu6We0+kRsQkVBJi7H9RlmMxx4cASyJfydSeNku7Q97MaV0A==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.13";
      hash = "sha512-N0hYFEX3bcXO27yi2yJueXNm1ziCqjMSEAbbZwIvPR82tQjPVM8n2IpLED1Jq7ut8ZJlBvTUbn1JK+KYhILlQw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.13";
      hash = "sha512-0X3X3VG/W+UmO9EiS88KlEQ8wppRe0bctvc5b6qu8tFBxRFfg/NBwriNeR7LMYa0AzNachpvtmkXHE6WyI5zJg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.13";
        hash = "sha512-W1OSZ3iDAzWFspWzuJ6k4WUPndab4R6p2jj69NcI5G751Co081XM+K6BSAISQx2Gz9BlIP9f2AwgQmc/qWUVsw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.13";
        hash = "sha512-+oFHDejFRowp86/LQ1YMNf3uRWc2v5IkRAe2za/khdJ4zAbc9LuvVAv+XRu++/Nziyvj4tFOB8KRPtMKXBl8IA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.13";
        hash = "sha512-EN4+Spucp/yPiEVTygA3FTTy9noYDxnUDDb9mQ6PB0BkSn5IN0lhINOPuqh5Zxj29NJU/59E1HEqLzbO4TFEvg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.13";
        hash = "sha512-xCcpVW3jRLfLScyeXIDiJSqpFI2r5+a8SEcjfaH8Htig1CH80Uk+h+0edGvPLaGEgwjJ/70mAuIhD+WXteH79Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.13";
        hash = "sha512-z5EQqXnArBulOqhgGZ5OlTknvQbLyuXCXNFYDKI9nswtixz24WvG5KqOxkw59pwTYiZ4Q/7aYQnvFq2SDQMcaw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.13";
        hash = "sha512-tpd4KGVdtjbQ3yUOcLhwqr3gNeHHnduvAM2giAymhIOpxFIiswHrmvzTQkh197MZk9ktvU55aSBkmJR6Y/lV2g==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.13";
        hash = "sha512-i+xeWZgxE1UWyP0PQ/QQUtsQ3VEt+DsjPZpo0Nsr6bUOxMX7MQBct8VtBGJ9HQG98yY/u94pdAPyDY158NFXEg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.13";
        hash = "sha512-25VU1INSGwOSmRgNfDWE5br/tHEGYxIG0syS4KNfgC9gOAtW+xk3ommYq8MIbZAiH1UaSCjJ4BDcnQzn4vTlAw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.13";
        hash = "sha512-GYbzBm4y5lgN1+S3SvVGj2374X+XmR7Q8NKBRY6y8TZDGj2TOoSiURg8Ijk5QT56ohIfSbOTCBfFIEVEZtLt9A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.13";
        hash = "sha512-JYesh+8IyrkVb24+GrWT/bQjmdPuox7WUd5HejKjeGEaYiV5CkhWUMVh9piZ2HHAnG8MhTQ+SK0t3Lq+S0bZkA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.13";
        hash = "sha512-TIxscT7D3tTYA3oRAkjkLuOT6Peup8n6fRvi56RGkDVLVaOK6aREeNnMYva9uD/PxQsyTDvnmpIHZmM7yFr4gQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.13";
        hash = "sha512-yJ3xUvojbSbYV4H8r3e3COtAbOoawASogXeR3WLUJGc8GSEAeJagtuKrZy6aE9VqCupXU8Hqrb8hnK7gVzniZw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.13";
        hash = "sha512-uTisbEjLVlrf4gAkvlA/mkJe7ISbhfasVMhMayPzOiw4Qv3doTPfPyn2JzfN0ZS7oKES1p8d7hVNmBzRtwu4gg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.13";
        hash = "sha512-RetqimPTPg/yCy+h+qswPCjOB9xl65i5HBgpsrM8HdvKoK9LAB2ZCnk8fVlwCmMKC5fyjo/ZpD4D1H2nGg3JSA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.13";
        hash = "sha512-FsGjvbseTDE2wxzyh/gNsjVLGkcoXkRobR/1j6NBX3bjDsaqey2NhKX/6pKImNkkiGtsb+GHMInGN004IkCPTw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.13";
        hash = "sha512-GKWEPtmhLGMQh9l0WlN2jfS8vils0LJhtASH5apyZtcz/1l4nUNF76H2KWDAYzp/9jOmXO/Z0eON9SBqE8friQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.13";
        hash = "sha512-+InAAsOlLBfH1XQFqvMl+KQ6mEI030werqsddjMxqftciNJucvN+nLh1aQ+5dIxKSN6MLDZ35qTKUwwS6VkeYg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.13";
        hash = "sha512-G5WG/JsgTaqozdSHLFij1Dwi4/OO87itbflthk57/Xxt4xvrnGwm11l3Y1jJJthdT0/pMWNPcdXxCCyw6Ly0Ig==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.13";
        hash = "sha512-Uf4w1PLEnY3s+vnPlQbXSsVeLat1+YMkbhXCujtRpCcVJN5CdSvFeRWvXJ3KRzy3vALWFER6Jpfi0rvFUb7Pcw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.13";
        hash = "sha512-IXeXEUH2P5wcIXVKDWp1UiKaXKVLFSGINIrx8JXSvM5A5wq+hcskzzjc/2Jb66MNSqqwkmlXuYT9GJ4yizDgWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.13";
        hash = "sha512-eHZriTZ4LguDLJYJ+6/ZjHKNEEQtDD66KjOGSTuFghMkC5GDs+glZfBN0ekTcRKFVcMYKGTyZgzg7/Ok0cIvpA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.13";
        hash = "sha512-gXjnZz62FwTvKjJLMOAEGKks7yQ1yv/oFYn5iQiPj5r8KcFH/vjgqyicni+V2dMQ14spzuqv6qAtBGBiM0JA9A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.13";
        hash = "sha512-OsD1O1kHfKRZZHlGb+6xgiiR0ibruR1PnAnnlOWU3atDzW5PvhFKBVjpsyGxW7laqGXIzf7pM1+tldUArhhesg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.13";
        hash = "sha512-HYI8e+pTqFO1vstW95B8u/NV9kjxH03kicf0Hnlh+/2JZDfCFEFm/4QMcK0SYpZiToTzsouhiAkOr+1l2FAwLg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.13";
        hash = "sha512-eVv6CPHngsyet0EQLuXxXa/R4OLyZfEd2M5eNPMO3lHuqaCmAneyrmuQLxOgcOf7cLEHgBichXeePqx6C75/4A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.13";
        hash = "sha512-HN9rPD3FRQ7HVvHegMmdJp14+V8ce8I5kXbQvUTfLU+tXdaELKg7NlpQRSwbkVIllJ8AB2XEf2v4O4ytWl3wqQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.13";
        hash = "sha512-8UR0QzIs/ZA/5SkXoHZiCWJEQvrLQlJlnUJt4gCQx+KDT7cANolKPyX9gsH4E/+9TFdKJs/tfH37soRCwNL9GA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.13";
        hash = "sha512-BRES7qJj0gDnx5zzIzDY4UEkSe7xg5J6JBTYTHUPSwyilRx04NRV/L2545VBpJCz5yr2A5If9tax/dLcgmOXgQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.13";
        hash = "sha512-DPs5wInsrAtk3Efh+Ey/Q+jkyPJZ/iWOlgskU7wlYgFV8FLWkw71AcSNxoS9sldWLZF0iza5T5qnzS0OFXNUlw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.13";
        hash = "sha512-0/onL7C/TK+A0kkCqMHWU7Ek9Y5xTgzL+Iu3f796T7tGSU+nCNELuAqvgf96Bz+eqE5hWZExam9QHQ1pQhBkIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.13";
        hash = "sha512-/1GyFapjXBxLallg154odqJBX+H/Y16zeM8S177ERwlBbExuKxhcpqgnFtvOM9y/Dv+j+q7VCcmygZghPtIf/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.13";
        hash = "sha512-/REkglvNhkHTaYq+6/YVY2rjleCzgNhgJ2/7bEvpy+38SyktZh19QmNm0261frVAGv2OWM5CtxO9rK1R6JYx8g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.13";
        hash = "sha512-UtomKpAPXuzPVM6axmBtkimSnOw1XY2fMTp1dUutLZ7XRZKHYIGSyAQLhy9Z85HLwifoY+w1zmN1UPLAGm+slQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.13";
        hash = "sha512-sz7bDdmunUmbyKvp6++QQeXRWWZLmNWlGtImV9hK1bDK1sISmNzUsy2yNvtgT6nc0PJ/lYQyhR+u8HhXP8NIIA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.13";
        hash = "sha512-qJUudggla9pF7Lu2Slk7ehf/CtRkOo20xA6X3X0SCaeNihP7E54wR2Tt0Qk2d+sTGDtxIcUQM3kyOtwZxrnL1Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.13";
        hash = "sha512-n0qtCo33JMR7lwmeLYsyBq8NBMidxrFsYKCT4oX1djpRMvNurWSFCCGenFOIKVG01U3aY9KGiqiOhxLs79Jyew==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.13";
        hash = "sha512-uFbpX/WQHcEXBamc1KKrFK4TTAzLAgaTdURPK8cwZNnm3FNnw11nB0HeK6RMCFcgkOH7Plaz4HB5JjF7phoxnQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.13";
        hash = "sha512-XS/HVpyRbqQuE9Y9YoXicqbFcgGB7tVh88VQLoA2Vhz1pT6K3DGZI7kAWCAu6pwATBYrzSQsSVK1HhHfJb3PxQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.13";
        hash = "sha512-F8KZvGile3V9I3PP9IA7u9suOHakrjSJP8OmBoQWzftjXMUnq2wQIWk4RUZHBMP8G6KwGWR1UCtcQgfpY8BlLg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.13";
        hash = "sha512-yRcefbz+OSAbXQpystuPosO4SHINQyzgWfCoeSTab2l2mHGIBYkZRTwebbHgoun4gJTULR7SYDl9TMOfXCSvwg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.13";
        hash = "sha512-Si4MeoFcFPN1n6/AMkLWWoiSA0El8qzjb9gpML+VnogO7n1j+isTDhrW9nNHxOQt9KsXq2zq3tfgKHvNMcAAUg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.13";
        hash = "sha512-7OTjwkb7R72lqa8vClrjZurvygsL8HJwEv279KUKZXR8/RxdMLoRqSzYCDCQB3BUOP18/nk0lBYt10MaMsDDaQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.13";
        hash = "sha512-Ut08+QwH68EMIWSOZSKj8ZAH85PYoV2t6Nsl0JBmSto+zDQV1kSJvVUcAOWVhXRWUr3TajEYh1ciay3SsD6coQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.13";
        hash = "sha512-FoVvaC5+klxdSFQ+YqBSb30k0uWSrSOyuNgdQD3OiqbwUWD9472gZ1h9pG2VtgDVW/6pjcRb3lI2OP7h7X1WYA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.13";
        hash = "sha512-9F3im1W+wovAJ0sEQdv2z1sm2Jg8JScsatWsXjeNPDGtQHyg/U1U8AkiEJSnUC3GlexbqzU8fQdWXTq7dXDXHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.13";
        hash = "sha512-ikfCFLtOuYsrW0VHHn7tRflsVENRgljMQQDbU2gKawFmPpp/L/rZeiHQmTBWjkVWNAUBvQWUucWZpxxwPXVHZg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.13";
        hash = "sha512-sWc2WzjucvCryxDBUDjCph71On8TxzH0BT3q3wJ1yVrRK/AUHx4jW9WjYPO0kA1pnzbI3PhdWgXwI4JndT4dMg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.13";
        hash = "sha512-rPy7+J7NX6nAjZpIzacxFfDe5B5LXP6IM8dqrwlLAO5dQGMhXNVbKwru2oAbiJGWrX/dLyzbR5ZkMVaMWdyR3w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.13";
        hash = "sha512-+fcUY71mPmn8arXzGh9MFb+cZkGRxnrfISqwS6uH0BSjRIzdGSuYzuWU6QKVgp9TGKpe4lx/SvsuqqgjRh9Bvw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.13";
        hash = "sha512-/EFfOaa0F1geXvwzCXiNvGaV6mqdNL7H2sJ6vLQ2mkMxplZKyRXdxRQ+L2CSw5JQPQF1Q+U8IEpM0kLTeTbL8A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.13";
        hash = "sha512-ZKcKUW4IxzzasxS+aitPrc4vkdyPZBhY7A3tZY/yyjU5DuY8YgGciwXUKtO03tIkSKEEYzgcaq5qz7uMcerhFQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.13";
        hash = "sha512-t1bre8Gyn+Lp1OEm/5dEr3VZGscoFOlY3vWxVfs7OuqLQKKrCYue8Z/hxEPvSEO1u6aI/BObW92rbbC0ajKUqQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.13";
        hash = "sha512-dYJQxse+wV2V4MWcHG7zjf39EWS0GciHpD2JcXJyyEtxgfRmMcOBU+mp+XPIRcH2YyKx1D406fa9jQVzBz2dyg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.13";
        hash = "sha512-w06ziBrKBpaS1G2Z3hM6GDYcBV1O/KRzH//ZS+IgjouMnlJUO2pl1PL3a95UblAywH3DrJHwLy8/yrR6Yu0LFw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.13";
        hash = "sha512-Jo4hEcZA/rdEl6NVO5iQDIiujr5Lhai/2SSgOIIsx0CnyCz+rjY3D3S6YlGR1AVbk9x/yLhBXRiPlyXz9n0y2g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.13";
        hash = "sha512-8G0d6zX9i8oThEA8ieZ6RUcIacpCEgja2grvCi4Z0DkWd0rAJFBVlZl/j9mXuGzMXGOawVo0sD4jwvpdlcAOYQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.13";
        hash = "sha512-FnYzH7x7GcAjBpNDzxabDPO8Vx3BvCSlcgusHolPhOKtHdoL787gCM8UHsEtE+ZW7/dPAAzLG2e4vQ2oJtyBRw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.13";
        hash = "sha512-vYodKjXjFrgqU6/nRj2GtAZV19+dPwPA9hkzHGqOgET/v+xAvUEJqbIFJfVjmldlVreyo80UDw0fVF/b4/X3vQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.13";
        hash = "sha512-ez525abCViQgUsv5gP8aZWRmBTj+0s+rLdsbBBTf1gY3Q8+c5aSxZMi/UvXCkZkQHsAknzBhefLF4whjQQK4Qg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.13";
        hash = "sha512-r4TXoY3hD8La7VrNzG0yiUUK8MlFjCnu1+gn5wrfQsbcf8kMfiUcir4rD52+wxGOFXukYGJuYpnLdA/TTDWnQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.13";
        hash = "sha512-DCbkCS2T/Xs/jvv1jZo5qPCtmliNWCRH/5rHfPQShHw2Yy9mydpcb3+a2zNK8Rm6X8mucYWBftlySHGVOQUzrg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.13";
        hash = "sha512-5KWhUMEaY212eyln62QhuCyeMK/uXYzi1a+IKf2sfeBnTRJ51r9+pduDYgL9LPj1VollpORWoZcvxSw4kuHxIw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.13";
        hash = "sha512-uZITxm3gc6ygACd0u+BLq6jTZ4plucdemr8hZLpGtKg8gb8NP3xg0LOUwBvMK50QbzFvWZNeAl9K1AKHtr6V7Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.13";
        hash = "sha512-GjdUsgToYNTMe8Wg5uDmsWDNvnsSVPkHlqBxL5ulOYI5ZrJzuq8QV6If60Qv4N+KbbSKRFdUyZ0CS+3fvOmpkA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.13";
        hash = "sha512-/CWAZtcRgPLHRsHm2p7tB/LGZxLd54fbX1H6XOJI4XF13TrkQ0eSXCW70yHE9pR6hsZcl6a+3XHo52RytkeerQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.13";
        hash = "sha512-pOsn0cBhrZpyplii9TTHuixb9w0PcnQZzJxa67z7/1BDdGck9ATUVXmO8UUrSnHI63+RepeMgR/Mx7jjV48o6A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.13";
        hash = "sha512-55suoRAIf6dVjOdPhHxIElDa2GBoqVZI70bG4zq+f2pHQbGV6yDvztsXdit4pxc3Ea79X0Kfo78Kncjt9NauIQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.13";
        hash = "sha512-bN46/mHfkhh8zP9R+PmFNU5v/LYEotfG8SRl7yBy3NnHB01ryupAaXSA5cS0aTj+QlGk3hJfiFYl0GFymAYQJQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.13";
        hash = "sha512-05cbPxBACiyAbBQ5l/OaUfmGDo0lKM4FnODbX1AkrFMs1ZXruYdYb5v8qQmiBypvXpDJQNfE6lA2UXb1ZJHXwA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.13";
        hash = "sha512-q7lmoi2Q2CWH/+lsPfvKDkCqq4ImZ3ybOXLzPp/Sw9eCeYmCsywD4gEmvDXlD9KTYE8srwwT3qdA9g7L4TeHEw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.13";
        hash = "sha512-J0I5+RB54wnCVSnTTeyi2DnBS3jS/tnpvhgfA0wBNAI6OeOZpiYz+n04NEWiwL5gSNqMvvDBh96V+uJuCmGmhg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.13";
        hash = "sha512-lP1mxyuZRNer4T8F96D5jdjr9UhK3panlJL/0YK+ef8W5qLCfaJBJg3hdutOASlfjM835VVa+jh8+pRh2wyxdA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.13";
        hash = "sha512-gILZxaHiA9fgxpeojkbhGWHbb+iK7f+FW9D6cvNJ/XbpPb7scKSgp5Zig2RKbhuYYY42D2/+F1tL1SeZ+cMiMA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.13";
        hash = "sha512-msc8G5hwoXmJ/h2NXtikbU11FQroY+hl7Mwc04wct6UciLBUKPJ59zn+Gjd/ciiVbTu+vl5dUurPDkwb8D5bCw==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.13";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.13";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.13/aspnetcore-runtime-10.0.13-linux-arm.tar.gz";
        hash = "sha512-pb4smGwBytJChSloBHHmsDDxCzEMzWzzg9r9uLl33z/3siHv3seSqsQfCkmG7eDKMBCWLvKgPCxgYy7zvCkzzA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.13/aspnetcore-runtime-10.0.13-linux-arm64.tar.gz";
        hash = "sha512-f3C/EvcdCUk3C11mga2XAtE/Xx5Hb57I8EVcVkqbaeT8pFXT0gGu+FAP738kRVsnh3IVIjPVo2odt96a+tTtNw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.13/aspnetcore-runtime-10.0.13-linux-x64.tar.gz";
        hash = "sha512-eyDUFk8Jfhz2FtgXS2pkvhAObzDcTgKLFuVR6LDIbf8O9CS7S/UtH/DsyjjhAtP6gIFOBsuFoy1u7kw7mXZPeQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.13/aspnetcore-runtime-10.0.13-linux-musl-arm.tar.gz";
        hash = "sha512-Uern+DQd/mxRoVQQru9+Pe9hn6sfjOoC8x2CsaColdqALRYXGDXKzxR3rG5RaiRNzV5As32J+G2acVP3zK2/og==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.13/aspnetcore-runtime-10.0.13-linux-musl-arm64.tar.gz";
        hash = "sha512-R7NonhxxteuY4ccpvaWDnvPuIRK5XJtsRCSglNd5Lxd+GLaAaEBcPJCmEFyfSBq8wHxnBA3Os0CxJc/4Zs3qEA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.13/aspnetcore-runtime-10.0.13-linux-musl-x64.tar.gz";
        hash = "sha512-+mDevIKE0BZ+X3voz65okZIcyrD6go8Cnd5H7qAf5QbZpFiBZSlqd45YzHiZT7EudbAOyghlsdDtjiO+gSST0g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.13/aspnetcore-runtime-10.0.13-osx-arm64.tar.gz";
        hash = "sha512-sd2/bERBz0k4AWuDZgZfE5lVHUOgsS5+ay1FNVqVUPTzn2lEzduuPo1pigYhOx+FufjiJNnaqOr1GiBIoGLecg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.13/aspnetcore-runtime-10.0.13-osx-x64.tar.gz";
        hash = "sha512-JB5O4LGnLrAyD1B+lJO9Zv4TMc1XHfz6si2T2KIa5n9SPIgGoXeo3wW0xe4q7eN+JdodwBv/xYKxQ8CLQJ0KYw==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.13";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.13/dotnet-runtime-10.0.13-linux-arm.tar.gz";
        hash = "sha512-sfLEAEwfPmutdEj3JCE9o1QoKzybH8V+LtSO90p0f8n7sjjWgZ5s8epKoXWiTU5Nn2GNYB/4r/xTGxyosY2/iA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.13/dotnet-runtime-10.0.13-linux-arm64.tar.gz";
        hash = "sha512-+fCwjn11/5UoMpJQv/5YQYqcHWokZ7x7wZZZt7OF1nxWbbhHfYDqTAh7St6yzAW1HjPsR62Xe5fx7tfNQzvoyA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.13/dotnet-runtime-10.0.13-linux-x64.tar.gz";
        hash = "sha512-lXTZU2QRBAlBZzXnhCeW+NYUwh10yyXSBKPkz9EbLAXv3xnKibgGllCgT2St0nBZZ9ywS4Zlo216PzCl2MBa/g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.13/dotnet-runtime-10.0.13-linux-musl-arm.tar.gz";
        hash = "sha512-2OArFCUiDyqAMHK6ByRYccSnfM/ANzsc2YNJKcGGdUBvlFaojXCs+rjr5TQ7uib64DyDZ8W722Q3GqBMT3Pr2A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.13/dotnet-runtime-10.0.13-linux-musl-arm64.tar.gz";
        hash = "sha512-c2EiaMp1XrAlG+0XOuA2Fs8Df8h5ZyIEZXfWEwo/J+c53JN+2PZHn35t3WtwNszqfiycjixcG3m9J7FmFYgeRQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.13/dotnet-runtime-10.0.13-linux-musl-x64.tar.gz";
        hash = "sha512-N5Dcpn4z77GuKwsN0Uyyg0gvNu0gEnDf+gqB3O1baZba58LTzVcjqOj+Ke2hQLSWaLRPOUE/dfjU2rzEgXSYnw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.13/dotnet-runtime-10.0.13-osx-arm64.tar.gz";
        hash = "sha512-M5xbAxtf19ZO3ScxSh0PihMguMYfmsMFwdTNthyUvEOEgoZ87qCdOPxxlNoqBeaoaxZJkqXseT6j1lzM4OprrA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.13/dotnet-runtime-10.0.13-osx-x64.tar.gz";
        hash = "sha512-dzz1tjVlxKA0H7VFfzR8ZEAc3HPtE840+ILJlPyMKjEcVumfdkPx0EiQ9KyK4sRSTmBz/VQmDi0+JTjtfJUddA==";
      };
    };
  };

  sdk_10_0_4xx = buildNetSdk {
    version = "10.0.402";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.402/dotnet-sdk-10.0.402-linux-arm.tar.gz";
        hash = "sha512-0kBA6B3Rgv4YHHGSEn2C4O/XgwtGSxBXeStsyfDOoeJo52bRv7yzqHok4l6fAUqp9opdE7xxi9FbidR4Z2pxxw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.402/dotnet-sdk-10.0.402-linux-arm64.tar.gz";
        hash = "sha512-24WuhVJyUfuxKQcgrDvzJLsdnup0UW7yke1Lsfj/bsY6F1kzZ/SbRWEV6LJOrW0MLs4oAeUB82ps1ERO0BpJjw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.402/dotnet-sdk-10.0.402-linux-x64.tar.gz";
        hash = "sha512-GQSpjdots0uni6PE+xsiRFUymvkcNB2DVHhDwYOeESsErmme6S+iRJqPYiSRlqk4cjB4wMYLn2XIhTnVaHcpwg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.402/dotnet-sdk-10.0.402-linux-musl-arm.tar.gz";
        hash = "sha512-YdgyMOdK5hPLUxgMQqR/U7kbKg4zP4o+XPsPxrMxjVJ3ISEeBY8MG3zqDGrv/u+6LL9tuyl/de6DTN2nc7CVyw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.402/dotnet-sdk-10.0.402-linux-musl-arm64.tar.gz";
        hash = "sha512-dpBDimT+mbSClLrykZhkMXIE6ZHcPspHiMISnUdAaGkTLuKIgcWIBxYjEJbFpWdDsiqWpXERWp8dEhkKBayjmw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.402/dotnet-sdk-10.0.402-linux-musl-x64.tar.gz";
        hash = "sha512-QXoQu+2jFSKobteKMGXIc+yP0Z7limLxfSWE1hLboh74MGqoMwuqPke9lVNgXpQ7Sox7jeaVfnUlF7yOQ/+RVA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.402/dotnet-sdk-10.0.402-osx-arm64.tar.gz";
        hash = "sha512-7g03nBROvd727+hR4VFIg9G2lUMNE7P7E+gVP4R24eWserxCwIZoRxqvTXOP82fPUwCYRflNIkuhJv6+dNALdQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.402/dotnet-sdk-10.0.402-osx-x64.tar.gz";
        hash = "sha512-FijgoHJh9b1U3eNwxTuQy3LwyIZn183jS9Ypl6Kf+PMjEPgeCMhZYqKwIhwFNo3zf7BJCbbxQxspP0Rez4lSkg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.113";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.113/dotnet-sdk-10.0.113-linux-arm.tar.gz";
        hash = "sha512-otvPztV7ZVPz1A/lJsFagWXgzg4hXSxONWHgrcSeYKJcTo2XCrSyXTENG3q994GXmqTQDf2uhGT7NgE5Ax6Q/A==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.113/dotnet-sdk-10.0.113-linux-arm64.tar.gz";
        hash = "sha512-UTFBQwNFnZdSvvAiyJ7GgbcFluVEVu4cePGKUvuSM/vz/bGLV9AT0THxIfxkPY9H59oBSFJflamCqbdKxYqQEQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.113/dotnet-sdk-10.0.113-linux-x64.tar.gz";
        hash = "sha512-HydG02hO94LEMI4FbnCek2GALgguQBr/N2CGgSUAmoruKAP/PuuHWH3GDHZuXcT5v9YFHGYKhWAsyJLDH3IlbQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.113/dotnet-sdk-10.0.113-linux-musl-arm.tar.gz";
        hash = "sha512-aoAd7VQQotuP5k+iNBrJxHs2lZ9q+1aLz/x3nTeXMg9y4cY6BL/DK4GpAcZuwxvSlKmAt76NrUsIcSrZToXEqQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.113/dotnet-sdk-10.0.113-linux-musl-arm64.tar.gz";
        hash = "sha512-JQt6kB0GhWjUJHW535lxtyYpjitm8HoO7oahT/EBl0M1eSB6d6zZPhJMXMFp128IfJrG/1/O0YIQY6o2yNz0pQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.113/dotnet-sdk-10.0.113-linux-musl-x64.tar.gz";
        hash = "sha512-abZq6gUzmIjurFIyeQZ25NMFwyiBRSwAVIVBzpmCOV+zPnv8IkAHR/bJq7kHCavT9HAkmVPHbaJRLmhVcyxW4w==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.113/dotnet-sdk-10.0.113-osx-arm64.tar.gz";
        hash = "sha512-H+foO0cDfhdWEVBPCyOKGNlVieFBOiLqRN5D2KW//Cg7mq29WyxN487yQ6xdAWfyx10i5ecZ7OpLnghwfKEFCg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.113/dotnet-sdk-10.0.113-osx-x64.tar.gz";
        hash = "sha512-zA0pqFGBhsowA+/pocyb7evJxU3sUVc88go/vpaUvfOEyYZciqBB8qpGkcDr9DHLOHh5bojs0X57v7RrPNI7hQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_4xx;
}
