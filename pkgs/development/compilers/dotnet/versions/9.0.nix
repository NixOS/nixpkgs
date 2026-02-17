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
      version = "9.0.12";
      hash = "sha512-5817H/yRWcQkLMRkMsSVc3PR4DI/hitOvQuLLq/BHlLgp4w3UwFi3o4M4Jtd1lHSOAHfrPwpi2NBn/naEUBQXg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.12";
      hash = "sha512-5nDinrAP38GLm9vqRqajAwBWosPT1XdQuozSYolM6yjV9hvrCKdBYtZW08Fu6DVxybv/iniSUJ7X7XbTDdpOrA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.12";
      hash = "sha512-4hfoCpfxyOxj2Fle4LCRIY2dcNnUEI+bGGXMm/CLD0QvPA6mEQGfo4gNC8H/2hjILkSp/8ME+7Gwj54oOk5GgA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.12";
      hash = "sha512-RFK730iWOlM65jA+n4h3GUKe4lqCe63+nZ2YXOx7PMlhahr0ndt6n1ksJ/cSL22aKAUTXwTc8t08KEOfyLzDIA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.12";
      hash = "sha512-3olAwjY47h9zDGPGcmT53i6T4kP/OGFquTw5gKqTdFNfsCj/iBN1AVcpJhKFkfqcBGeSw+E6v9++Squdosg1yQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.12";
        hash = "sha512-tf5Twwux4OE8o6btmRLNigyd6ShQXKhnqgNtvFjXHSfZHK/piirtZoHesIc4UrPz3iXMKe5GhlEQDqv+owJo/g==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.12";
        hash = "sha512-raHt3dRPaIEm7cJ6fg4OKDWZ3qTJT/unuoa0DdVfiregOKsnjBh3gK9wcEtIUArdipEsxOxQhr8KQNf/1Oaojg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.12";
        hash = "sha512-MuXzjjt4OTnJAz8/TNmk06MYbvGiOZ2KuCTWROHaZNkQrKycMpCteMqEbcuGO8WQrmqeiquImRg2cfYVyogPEQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.12";
        hash = "sha512-VuxSpeOyr1YNywdCLmGgJtyYMjLsf5hY+sBnOFiCyPoszbIXj2Fg740RO2ThLzn8ca0dRe6uEBIT8kQTeLo6yw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.12";
        hash = "sha512-kxNsNovEhePL54Scx5DOcDqJHtE/iZFc1b5lUPUSzixjPjfAg1+VLpiNWfQwOYyN+vjRRFRGwqt8MoNfTJopcQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.12";
        hash = "sha512-+RekUkX5J6WKn5baTkQLJGAQ4djh4PwcOMhl/rW4v4lmTsuo+MrLAnyR4Whw4dDIUrb90rFOHKnihYpGCstO+w==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.12";
        hash = "sha512-ItmsEy9JNguIMwAexV7o3XMiYtYdHCpWdL6ONRjWwaZm/mSJfeDSNEJLK7Yqyzfrl5RY2feRVWsYN3ECPDNhzw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.12";
        hash = "sha512-zusNwWoH/UMcZSAkrDLEBJGXp6W7JdCtFxC5/JOdQqwg85O652L+w3oyDOHUDtznL+d2TRZHQe9puQCbcO8iMQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.12";
        hash = "sha512-vuXFRIOC2hYvQLnHGLRd7o9Jhp0ddM75qxQYumftgCTCVyrwQXAol8S4ec7yu8izy3mQN5aIANpM+IF45Tr7vA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.12";
        hash = "sha512-z7WO/csXBc2z3zEs+HgZWhCmkthvNzm8kMflEOpk4Tw9U/EbEkzf57kQISDBp66MkV5mIohgWxXsKyrFGzANyw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.12";
        hash = "sha512-XVXOHaZgV3Y9n34e3TZLZ0p1Po7XM36J2r3kjsLn5luV9jktjA/04B5VSqaz1hSb7ss6n+IOQt2qnZ1pAjCeJw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.12";
        hash = "sha512-X5c/Fg1Q7QpDWXsHu98kZsOF3xW3dNFziChtMUznIR53zSN27cfXVGy9MGAG+GUi+CiQRKe4oKq9kBOdRDR0IQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.12";
        hash = "sha512-3KhOiWEcrDniO/vOaYqJFlRIA0bjsiogIx8zYZssIAIzqYy2IzDmpCPEkhhsbF7ioUeWOartETr47Eg4T8D7HQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.12";
        hash = "sha512-BpkzpAa9wPPFB8eTaz2EnVf434WIMsDxwz5gXIPUhptDjLNxkxdDvhBsCoRLvr3ULz7JiC204j0CqFV+BLIWAA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.12";
        hash = "sha512-3PpKrWQ3pH/frVLwfyEUy18pROlchMeMJ/LUzLla3H96WXDrMPnkNT5Nyt0rjBuo86AwrgrzNDwzXQpryoxXfA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.12";
        hash = "sha512-e2LP9dUxRxdVhQLoFHpWWciKwvogkAU/ZYOyAm5jz4MPkkW48aeLCtQJIXjv3UKgFE7Z+xxkKtekYsV8u5zsjw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.12";
        hash = "sha512-GrFpyK1qTpTrKONC+I5QNU5CbR1r5N09ATduJq0JfCN9wJ3yDjhEAibhxdoA4jrhIz98Kg6vBwg+nVhY/+AovA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.12";
        hash = "sha512-RNYYAIWu6TcV9UTU1tROmGunupd0MJlzVwNtZVcRELLTOcEypd1HW/qdXsCas2gAUrGSaASEwCXiGF95BHUKTA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.12";
        hash = "sha512-C1uJ4sUbOc1xBHb0gXwcv3449ZY/Vf0wXSMlGx0DWvlzBqgqnuQ/RuosajM8xEeUdKzrSNTlnnWn73A9yUmzhw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.12";
        hash = "sha512-nUrI8pl807XO1XxxCZtE3y9KMToP+MpoNKGtfHdrncRa8ptBDsbA60AhdHdEy+5oDJUNpTXxRuclM2mN0a+Y+w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.12";
        hash = "sha512-J2ryWVyTbnKVPQ6gZ7gtftJowLK37NL3P4MnyOijxeo8VRjpL9isWIzC4zPUjuveUk+4leePiP8nP8Ce3J5yMw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.12";
        hash = "sha512-G/rcP/0MBrUQe+hPWv728mY0bAxAXSkuASBueg4NBFlBhGbZu3sHvcyeJbTddxj1UW52/JkKonZcGJBrxTyJ+w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.12";
        hash = "sha512-37F0lOt4nMHUOsuhpZfpL4mKOAWflCxbrrQq6YuenNVH3WihoaI4f20BLPlIAABw2wGdPqMzu308v2DFdQP46Q==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.12";
        hash = "sha512-b+3y/6xS7/7+SymhKeBdt2EGS47LWE0nj1VefWKGlnqWCNcHnVQ4irBJSqq80J02KorrM8Cqoi6tQ5b/dkQOyg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.12";
        hash = "sha512-j7FlhJSTV8TQ3PXU5Z5BspeDtt+C5W+wqXT+lpPU8F70EovxUj5q9Js/EeF3nIlBVvK3BE4FVozLVnZCiEQ00w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.12";
        hash = "sha512-8QV10AEEFaLZ3R5rGzGvAaJtipqVnijMnh8OcfOmw9bZ5rbQ+Lo8VpX1lcgVBeXbwxo+p2ooZTxppkgS4Q3ITQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.12";
        hash = "sha512-0e94crtwx6v+Nvw1w6VGLVes4xLaPk3Y0X7wjNK7DWB+ffCAwIsxUXwgARp6fvD5sHIZrM7C2JA/bv4fg0r1cg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.12";
        hash = "sha512-BhYmxNPRgTM/7XcNmiQEv1g3Sy29NGDy+S6YkHtl6j7afGXCOj5bstjsHkCbvulakH00FSxjG7L9Yk/t7NmpDg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.12";
        hash = "sha512-2zGB3GVLOW6AVJWXxedpGa2dED1aJUEUv9NJHBN4ivIcrXk/oTaozEuJbXa+Gb2mFWJuFrnIcxLd+wyoLAMueQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.12";
        hash = "sha512-UDNuVhtWm7kmSTdpum18zAkSw5tutUHDElrJuwbZ4+vEGL9QmXhJ/zVdedk5+A2u1OMOhONkN8eAqyPjxUV0KA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.12";
        hash = "sha512-AZjU6ZqrYKo5JgdyoyxWU6ucFALDRVFTTbc3lFFxuvIfpuOt7mm/MB3FhxlgWq+BlxhFmV8NnIxXNvHS6jABnA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.12";
        hash = "sha512-iE3arX6H0ePpffLFBMgVwt0R8wHqbnUSvBSp/XdMdBnd8k3YgP2R5Mupcil7Tb6wHd9GMp8ur0BUb6proAvqGg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.12";
        hash = "sha512-Qi7KYblVAXQby1XBXJa7ILe9+uaC2cgpwZ1ZNCFqAeF90A8E/VMWCclCsaaengCo6t5hANL0QP8GV8HdgbgRsA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.12";
        hash = "sha512-j/XRGh/fmi9GJ5jr9lO32I23HvDkjt+xN0/6N0XCxqmEEr8ZwXYlgtjEyro7GZeOjI5jm5EV1pmmcnLk7a9DoA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.12";
        hash = "sha512-e7xV7KNQ2PFXa0poUFIaLqSPBx5+8TSX1KbaGHID4urmI6HAx0IlFPLIAJgKNh85DnthV4EGWbFzrZ5uot2Now==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.12";
        hash = "sha512-Nj8O23C38JzZm8BKg1kfEADav37pZkeX0vT456x/g8PXanHEq/llIFkxNWITx7EL93G8Jr89VA+yHFtdd66r/Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.12";
        hash = "sha512-WdyvVAAYfPtCSa0aZGuSZ5vccgz686MBMUown79ykWhavhhyAlYM+EvfE5XQzi5iaAxFJSqPpcY7yfv6g/2Zuw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.12";
        hash = "sha512-ItlkNHAvDEs/bm8LiFrHYE6nURLwHFjy0Phtvdcr04t0SqWWJtUWb8Zmj2RVLi4KwFHks0TS5f6wr/Oc8a7pKA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.12";
        hash = "sha512-DAZ7Se/m5oURYA3p+FWhajtt5YWSWQOJ+vpLN/UIqsawoAwmoWrEWCE02IV/c1g2Re8TkgmssoN8eK9fxRMlqg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.12";
        hash = "sha512-FofaDnwNCpz+vYiw0d8rhaTuzBn2GJ66XPyU46KuyqiN/dgiDTA94TmwCGKGsNb9085YpRDrYT5amuPMK8Hm4g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.12";
        hash = "sha512-wFC7rz1nmYi9jnLHkZ0Dt9Gb8BnS0lr6CcS41QgfFrbeT6YlpBK9d6o6nBeGNdKBrRJJApKdOfxZyzmwpmJhmA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.12";
        hash = "sha512-KlbtvWPA6iKzn64hHIJxYQ9iR9Rm9vS5nu5N55hK3Y1f85nAox92uUFxBUw5AXL1D6gN/oN/QhnclJq6LIZhVw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.12";
        hash = "sha512-VhTsxiOPEcB5xCPEz3FN8KBVHvyVHiIrXqgglsjZRSjDRL5bE3ORMZJWMu39nau0Uqrg5ipjkKAXH0nro+smOQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.12";
        hash = "sha512-AwLNQcFL8pYPRIMBIqWC1Ydyqx78jSXpeEIcxi4Q9BW0UQX6WAu170CQtrqNHYDxJlhAFcVag1CAztCCSytBpA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.12";
        hash = "sha512-PQc2cXheChAFslbJp4MyHDK4BxXfxcvuWDkNhtcXlNgcjklNCMlATvsJaHXvssvlzjgWbUusTAKCHANJyhI12Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.12";
        hash = "sha512-C3/jykuAClfTLRjyilGERflIT7gnRugAk9filvLjNinQ9+cm28NOpyZ/8SEAZ6bD5BFMkFtw6F1JACWnERzobw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.12";
        hash = "sha512-6LQH+2GNF6OrVXVFG9H+NcFptXY30kxwjgjPbgnFP38OgOKkFZVb5aUU7i+Les5iDP5LinTPLObbfXsRfRT6Pg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.12";
        hash = "sha512-T4z2btf6xLmj2gQSTtpQhog9mUCdbIRh6BNoqTEqLm3xU127iRcPvxwNAYvl3xLQYHixAy8v2mHek+3RsNX8Tw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.12";
        hash = "sha512-y0xbUlkhumNpNju3kGKEaN6LbFdvpSu55b11+pnkiWuHSSJEJrTLqZtTqDReNvW/RjHYyrtFaG8T7EV65TAfnw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.12";
        hash = "sha512-0ljvWsHhTW2YcEtnw6l0odeHH0K4UwtI9N+Jx7mcYhqcLKaAWWL03NX+ZyLXjtGYjqvjlSY5KEJCmTsClaJ0Mw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.12";
        hash = "sha512-nAc2R5V/uuqAXz0br5iXnyZf/pJaN0dqB8lWVfSarG1a6aAgTgPRTtdqpfQ1nn3OVSgiRvivMSeTcVna6Usdlw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.12";
        hash = "sha512-fw7GPjn20glVSNB5oZo9pn+aSrOuN3FFSkpkVvJ7IBtu6iorRAcY/cc5rBevrojXfMtpVCdbJie7oqAHrWKW/w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.12";
        hash = "sha512-Gy2ejS+Uv2y7Y5RBhRD91Fi30b59zqMUcL0MQ8LHCaQqcow/DsMvCONymx1AAsLrQTTbE7jQbljDf6t3kgnqdg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.12";
        hash = "sha512-wFWNV20bHO+K1lDUC0tuJkouhDeiQD5PhO2Ux5mjBSt0IJVkXrrLKrAXj490fRjhQOiGhQ4DZsJ/QUiTVe9n4g==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.12";
        hash = "sha512-Z7lYvkWpLxG0CVvfllRetwCRoZ75LI5Ydo00w7lGkrybFQCh8GNry/Onaokt/y2k00A/YuZTaY7fp837UyU8oA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.12";
        hash = "sha512-HkRwpAAOQ81gvpWPVPfnCwYhGcuJ9sRwqYcRsuRKCFO5k/DDJBuTxVBchWeXDd3ata16AnVheLloITPllibTpg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.12";
        hash = "sha512-xss608ooQxzPSBeKaXX/E2wFQFCESJvsg8qI53yshMTTuUId31S9Nag8acKllfUJ0X59OT+mBEwJvKDTGpnavg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.12";
        hash = "sha512-vHK+UzYKQtHYWTKuPlwTfEmyaPKvaLoo2AgvF+KmVDk7zzEeri7x3L/4DKA68pfCt1RroVHpYrRSevUIjWUeaQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.12";
        hash = "sha512-ArqTRvtlgzf6RuZmLnsXpXuW7uocFHkdz219v8sLOWA1kILjSYemqnLkVkyPA2M2ut7MVGtmdcC5B4qFsB8ERw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.12";
        hash = "sha512-UOcPTSe8bPHPr9weT4RWwzKpwUczsTqyhMOBCPCnpqK/aLrTwm9ihx55CSG85OhpTmXthTNgBJlWTMAlEGN/+Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.12";
        hash = "sha512-gtnlrdLTGjQWk2v71rKHBYqne43xQpFnoNeVbwirLpVfnlJtsI+SIvtg73fHSAlHxvozIN71krsNlu/JYo7vIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.12";
        hash = "sha512-BpzECjZ+jYeY3EudbqJjy4q7L87EriUwUgDmNC5fk3OQbna9XXIjPV8qQsmYDoHGsLiW9L3+X6Yc2ybPIlz2TA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.12";
        hash = "sha512-59TJeZwFNAUJnFs6aKcREL1sUDIzIWZRBo+tujgD868lt5vXUpqgEUJKqeS+B97Xus/NqTfmegd4MWdic2Jotg==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.12";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.12";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.12/aspnetcore-runtime-9.0.12-linux-arm.tar.gz";
        hash = "sha512-j5kcU6vpk17LdnbqQG9davzL0BXisZaE2dlQMmFUVb6nGes9HD3HzK360mS3mHlxCsb0Kgo42Y6Ia5l5Vt9Xfw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.12/aspnetcore-runtime-9.0.12-linux-arm64.tar.gz";
        hash = "sha512-lFn9RlrAFBiLRA4N14VCfjU4Ik03V4pHNDguKnBpwNhwFOsH6YMJOG4ZW0SHU2+NjMsSb3F48uJSGsk0v2PebQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.12/aspnetcore-runtime-9.0.12-linux-x64.tar.gz";
        hash = "sha512-SJuAd/JmHq6+QhFAd0sHaVGcSWOkuy/n1e/3LJmymoHVrGaEcHRJoP+ImgdLbuWPtNAKNGuFn7ddHVRw6PuSlg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.12/aspnetcore-runtime-9.0.12-linux-musl-arm.tar.gz";
        hash = "sha512-MpUiRjowKX9mc6WJT3hzvKfiQ8cFHP0kXgYfYuqIpAnnY7fFNy7xzY+9fp7fFr1CrA4j6yaW3bGod4k4JU3unA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.12/aspnetcore-runtime-9.0.12-linux-musl-arm64.tar.gz";
        hash = "sha512-x8Xhkmz9BfBZ8MtrqGgx5+VIxmQyZGaYFga5inZDPEInlhxP7PyRRRvPH1Ya9YDn5PhvJ1tt8VwGhX/SbNe/tg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.12/aspnetcore-runtime-9.0.12-linux-musl-x64.tar.gz";
        hash = "sha512-kL+Rn5GacwtGvNi6QuSegxvyrgBwKB/FJoensjI5zT8vkWISnqdybNBAqBtksAeUeFR/oNFWh5a1uqTRM2A4iw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.12/aspnetcore-runtime-9.0.12-osx-arm64.tar.gz";
        hash = "sha512-WdKn9YqR4v9qGLJie4LzQzwZ8Z9Hw41hsO3Cn9L/wT7Rb5FDYRtrqZ9as0hNlnlTHRGPw5sdACauvhz0X60GsA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.12/aspnetcore-runtime-9.0.12-osx-x64.tar.gz";
        hash = "sha512-23YO5rRFVYbe0EYympkatjDCAHOSgMGuG5oz26pYo20kI5F7ztEdPIQJoUQssMdf2DBx9IzaHi8mtN0dl21Nkw==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.12";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.12/dotnet-runtime-9.0.12-linux-arm.tar.gz";
        hash = "sha512-YBcggsKqtaE1rHpz1Yt87vAq5rsdZFwNbl5mYEJs7lVBtb5UueV9EiKCXOWw/Kn7w6kIELr4jKaiLrtsIhjivQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.12/dotnet-runtime-9.0.12-linux-arm64.tar.gz";
        hash = "sha512-NbpJOewFA7Obh5+jbtuQgtgnT0MQL+osYuWb+rbEoZ/JoFES7msbRwNPmjufHlZ8ErhOoV3Yrvma7b6lUGw/aw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.12/dotnet-runtime-9.0.12-linux-x64.tar.gz";
        hash = "sha512-95tFXJXt29sVXScVxoPnRFJJpEsUoKhu92cy9W2sC8Yvejg8zXETClZHesA1PC52FFvdLECE08AhMmuGynUZFg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.12/dotnet-runtime-9.0.12-linux-musl-arm.tar.gz";
        hash = "sha512-5A4PbE6pClkGzLosax6xwUSaLfnMzuaD89Ug2q+y0Y+Nqs2mMCrcIG7Fd0iv9G3E8bx7CcpzPkJJkp09lx3ShA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.12/dotnet-runtime-9.0.12-linux-musl-arm64.tar.gz";
        hash = "sha512-eqga4Nj5kDPrOpT6dFxHCnK40rjL1wrm1LlAtSG+N35YEnbybm8AfOVP/H2BwGUBXHpo1DdWqKDHuuJBn14BoQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.12/dotnet-runtime-9.0.12-linux-musl-x64.tar.gz";
        hash = "sha512-ZYsvpjUdKyewhyDTXBIwGZC4gpc914fRUOAevPcXi5r67IW27igI3KO+6md/Asto+lCGwqslR8s/9oSAcTEiWw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.12/dotnet-runtime-9.0.12-osx-arm64.tar.gz";
        hash = "sha512-+rd2qFuKSrvdhkZvaEFG5Pv0ebJuVwbskX+oGcX5tiWIaPP9jJy9EDmEJX1tHJaJylJj4YMxBQLRIAhBVTQ1wQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.12/dotnet-runtime-9.0.12-osx-x64.tar.gz";
        hash = "sha512-ByeKX7NKzgpfOKlbIuYXoOP21gx7oh/oTp3kBirRlxbEDB4J//Mvi8ELGhc6EfmYQsgsd4G9V8OFZnQaG/ivMA==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.310";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.310/dotnet-sdk-9.0.310-linux-arm.tar.gz";
        hash = "sha512-tqTok1za6Ib+H+IQSTvF5u8FjgDdlXNfw2IlSTjcErd/RBrWiNFhlTokD7KrHX18WT9gVev47TrO3PhCjrjC8Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.310/dotnet-sdk-9.0.310-linux-arm64.tar.gz";
        hash = "sha512-ZVm032pEspC84iiiACsczG3APsAEG33AZQB6hd47Mu0ZgKGkD9BtNtHcePCBEU2oyYcF7KS+gyVcbfhkcICg5w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.310/dotnet-sdk-9.0.310-linux-x64.tar.gz";
        hash = "sha512-ggP1ZqI+CRQjgbJzC6Lv7XmpMkDAlrAsmoNB6V1VCibZwxSW2bEc4k7eYbvX+3ITHUz4WIDRAckK6E0kQtCllg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.310/dotnet-sdk-9.0.310-linux-musl-arm.tar.gz";
        hash = "sha512-4f/aegDC/unHy7NsFoYjjNh/ttGno4QAz9VQky/FUt+1ietiJcM9gwbGVzdXjp/C8+SjLOVs9PlDW+jbUIb6aQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.310/dotnet-sdk-9.0.310-linux-musl-arm64.tar.gz";
        hash = "sha512-+vwCicaA8n3DpPRt8ykuP88uJ6aS0Fj5n+JtxpSwzFm23hIywVRYPkNTge9oO1Dz9emA5bfF+ssZHyxYg5XdRg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.310/dotnet-sdk-9.0.310-linux-musl-x64.tar.gz";
        hash = "sha512-ak1+1wyDOzQnckD/1lXZgLqn+gT4xZPGCH6XJp7RTMYaclIqNJKhLmrWfINLV4CWLDpiY3nXIgRVOD6o/aVc2Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.310/dotnet-sdk-9.0.310-osx-arm64.tar.gz";
        hash = "sha512-XPsMA2axe+WDk5j/re/R3qobE9CDrtp42ZC5plD9n5AvL255nxbDEY6qxMvkrrXXo6ndvBYK/EJu/7XHjdS/EA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.310/dotnet-sdk-9.0.310-osx-x64.tar.gz";
        hash = "sha512-0n5VuvI3jrFjkaQNMFind0Ipe4RGU8ltTierVVetHxxsMWjtDDvSExwidbVxjLOWq5DGx99FlN5yPwJ+HI2zlw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.113";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.113/dotnet-sdk-9.0.113-linux-arm.tar.gz";
        hash = "sha512-1ToydcbskEyhZvr0IA37cgjq7yA76iCLyA5y+36eeHL50HgCgqPEsNdiVjZlhL3OngufTTAmdPzgdk+yCVfQCA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.113/dotnet-sdk-9.0.113-linux-arm64.tar.gz";
        hash = "sha512-eafW3Z9TxDlPOUZHWi71iAzxezvG+suqn9FWkM4FnMt+CPhvlfqDOMeEAz1KEBDN34ftd7wR2/zaEhIV0Zmm+Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.113/dotnet-sdk-9.0.113-linux-x64.tar.gz";
        hash = "sha512-FdrZI1CCbOVBQV7zUiHLMcxHjUqceFOfB3qbw5jzU/9z7w5UD5rOlSytJqMtFXbEA/z7x+Luu4RXlJm0MKOKvw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.113/dotnet-sdk-9.0.113-linux-musl-arm.tar.gz";
        hash = "sha512-3Tg890tn7Cz79fzRjDt+NNjGJITdulzj7DFHfgoEcqmib/5Et7ilNrPjMQKaTyZr9Dv9WIznbgW51X9L2kXUPA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.113/dotnet-sdk-9.0.113-linux-musl-arm64.tar.gz";
        hash = "sha512-6fe00gNJSz20kVXRQ9bjtPn6dg4U63wDMBRm648JZYhBG8kznikTqM/sDvS/YyD9CSThe38vJ3Q3NDj/O3b9ng==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.113/dotnet-sdk-9.0.113-linux-musl-x64.tar.gz";
        hash = "sha512-HOzdQO5KuVAtvcchRddofZWFdCP+QNXoGatsAVNomsxbm/pRdLikKK/Anb0sa3m99s5OjqDuzTLG4bdHX8H7Bw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.113/dotnet-sdk-9.0.113-osx-arm64.tar.gz";
        hash = "sha512-VchzCqQIXuAJlP31NNRqfwfcjobgwYDuCcaFIKQm7nUncMSmMpZn1sWu+SSLUeTrFGCvb0n1dsDsPPWRv3nQZA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.113/dotnet-sdk-9.0.113-osx-x64.tar.gz";
        hash = "sha512-ShegsbkEaYqopEUNQMMQmYAJL3irwRrRY+lMCnqLkPK53Qp0pRJmv06ehPWYOiabPyDe3BVFQ37w3gECIgLqAg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
