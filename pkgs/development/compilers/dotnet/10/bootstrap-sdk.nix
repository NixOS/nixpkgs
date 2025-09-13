{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (go-live)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.0-rc.1.25451.107";
      hash = "sha512-0wQQq3RPKM6EU5FXQT7bMvbPsKE+6UGlfP5FHQh/91fb09/lhVlFCO9oMUOkX8/ntQN4w+eqnrB2tPCHXu++iA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.0-rc.1.25451.107";
      hash = "sha512-hMhKJaqLUWSaHBcNP/OLQ9RFIppWqztgWh1Mi28aCj6a1+aTfjLNc9NmAsGC27SeqIylMYC9zoKTp6BMPdF/fA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.0-rc.1.25451.107";
      hash = "sha512-j/HfJgOT/5dMNPQsEQvilDp5LyTRa5SIVHZ5dYsckLrnlff5KHot4lYoyPvQNfFzag1hxsgMUtOfbslDFHUEGQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.0-rc.1.25451.107";
      hash = "sha512-0x4km79b8z+HFPd1qXOhx65BGDLRYECLKbjyzhrFaOx69zBNQHbL7nqTS+qXZ0BzckdGEBARrYa80QinpIIF6A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.0-rc.1.25451.107";
      hash = "sha512-XisyrroZsOir2prziGawVqx8sVAFvyamu5W5ordZYYuHIr/yeLlC6xDCgZ1CMhHE00ElUyc34ChHl6gUgQdCeg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-OaAv+l8BEw6MTrpB8e/j3QBGRR5IUr9pX5cjP5e0ooc71fl2JYVmcSgiY+D3diEHhkCMf5T9A+esQxctbZ1CIg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-gh184Rc4Jappn49zJ8Buwv1IQYjnTsS5Y2NRM9Un9m9lazL4vGTrnn3JArCJhq30K9Fhs1CkOZdbqGT3RFNYcw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-qkVVYbGTFTdyrLjPTbzglGNdkL6R3z/DBs+rxcM/T7AVwP3Tz8WKkoFRZaRNclrwR2ZuEEACBvMULpTAF6HJqg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-P0WUXdJK1STziFoDpTuMqPy8uU6ZyVaRe2zkoOZsQZi61wKjT2SDMvF9hn6qWlcOI9eUS9sriqRsErrdjiICAg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-6z1jv0LvBwHU+vshvjc/PHb0f5QtKpTukl5QajjcwzP6sJ4tBKJejbNNYuFhUECsetMbtszBHhTuqSC/wTY71A==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-EmYPxjHZfLErsOcJlqBwI/zk74tHsT46ItDhn+a8OzBWJkFBrjpbgjHwyx9kEYK+jrXZv+o2WpWVVtmBD/+zyA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-6W1aeaZGo6oQGRAN016jgsLev1RKqktn8w5+omWLgq5L8Rq1SCMp1qrutiJmMyKHS++9c+s34ze5uF8iz3jnUA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-pZ/VK7ghPyIZGg0GOJpc8PWuv1PZe30t49tkBpT7ge7w2CAs+JYHwLL1QpkRVuhlokL12ReASj06DNy6rAMV5g==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-k43sAfvYJ8+dupxMpwBAuY8g8Zyqt6yvaZfguWfZDe0o7njGlVXhllq3IL+v9WGMjGf4Cg1WEXNDuldn9yVzhQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-Ikd+sEhKE0Tgl5jrGGQgKvVuk+/e3WmXZcUwheBmQqpggs7YMMD9k/BMxE5ro5G9ENEmP8hfJ9suJxG2OupDPA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-FxbAID6dZL0aaKDFr0usSHWC7JZ0ZqZVMIP20rWZJ2Qsvg9C++yoMoRxvfj/WD6ZIbSaU0sg5HxS2OxR1N37Kw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-1PC+i3R6fAauQoxegCNPHaHx4hwkkHv6v2+OotoAGUf1Dz4YyED/Ho10HW+fCHklBmHkcg6CMMC3IzuPIo7IXw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-s6K4cCACFPHmvJddqn9zVrz1za9CjyOMNgsZA4Oi2ItTgsCB/pQzr6IpCUzZKrMWiojxHCSx/uch7V5kWE+GVA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-SawdfjnEJnfC/W9ptl89rS83enNKCyoDN2x459bx7I90U6AfGumGd2r+phGBGyHRhhiLHt7+z+3mzs2uuId6Rg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-rHnlR/R0UqASrXuSQD2rJoN4iOrJcexSHmk9nPfCDIgNYSd8c/8JE17SGU7Y6ufR0JuiP1f09KV2jibaKutHEQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-CrFnRAHFOQUFaU3Q2XlJeWN9pKUX1YVZDTHpZ/e0+t1ZfCuu28CRmCdaB7OoWcwRRA3z8CqniK/sUpg+VmJhfw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-mnfrlJ2jELYNVRZEXsgJdseeiEIkjIME6I/GFO8jUaXW1v1ydYSs+AycagoNqNb4Ac231DLnLu8LU15M2YJljA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-ELGeVjCCBpYHZFl0wYqztcb53M8fHcuhX8g5Hp6ycUlc9sD6Zg7lXOh3fXSHOf73wEG9125DvC9U0eMnnugV7w==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-DQ4H2zfLSkyh8LyfdUUhgaWIZWBsuK++gE0++1KVgm6MceKAuoShj2vJ7bdGSaSJIrlg2Mcc/USgNpdRcXt4vQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-V76NEL8Pf7FMvaglUhYTWvmbQlQHF4MKTWXU5z6l/63E/NE/GijuXi9+otgGmlfxBKCsdbCm6+JoMx3H1YQy5Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-HVKJb0V/eNXtq5wqhN/cSYcTWpTVtGQCg1ZhfVdAftkscOYkSv+IoDWMptmoMnmW91jTpe62+KkqoymNRQ8uqQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-XooWEHZOLNd9G9+/Vh6zb7dP+FiW5l5DhLeWLreThBr6PVvojYf8fSB/J7gqk59x+mjgp+7JyLWDRBljiUbM6Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-Z3tvIyDNhcR0Io5A/SxfhegCxX7wZwja9v9o/PJbwFgAJKby3YLv4Z0bFVt6h7UgtcMZQqzHFOn/pwsTEub0Zw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-MR2RtWm4VBoGST8XUmdEIQrLVktNkp92pblT1NSd5M09v3pU7eNeKwt/BvO/BE+UVrsLbHXrXAJ+rP3Ycw7qqw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-/za89BIwa39QXQOKX9S91MAJqnO9Xuc3s+LTiTK2/rwNYJy2TwB+wB8RKqjGg/Z8nejgHrjC4+7V4krvVBf5Rg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-a5mSgakxI87jUB3EhXje0LbbU+RpYFq+kI169o7dLH4jg2nDE173cvh19psJrM08ktwOYClGyvIAuvmeEwX1RA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-zR78sN00inx8O5CyDdDcwuvwUApTZlYSmA5t+wd9mzzKVIGbZ4Cz9vEcpN8aHUN1XDEBATbx5wSkjB5GepfNVQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-BJURYGy/fPMPR2V2ba/rtHCTpUfJzioEYLZcckSUj3+wYsrMyy55sF0nI9Ds2p8Fg/EalCFXoHYP8/2euX5Vlw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-oM+nJTEa7d9PHjAMuUCvKDtqqPPrFXJpoMacVPgYw3pAOsSp/g9mrULkD/h5paeL5v7cAsSf6bvHZEUkoWwbIQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-znRScAxeGIwwg6vKV2ADd2EDvfQLIubASsgoVLLVAOIW+W2LGF2Ia3uxgozn0b9wf2fV29w0S5DaeY97xl8DXg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-xA5c2BK8D2p5xsJXvlIutBAjVBUWUVM1f85doMoIgzPwUaceyl6eFsEQ2zjDh1HCgtdkGFeJpGQ4aDzpKlpa3Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-K9FqPXfxZLiWkreTc8hXclaxo9mQ4EkHeAihT4NARE9O9lkVOZTBEZo+BcZuZxLZgO3Pj6GtBncMvTBKn6r/Hg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-a6OPa8GApjr1CuaIREog/GL9pzxHiorvCP/YaYZtW0yNtRSv06cbdwEB+FYxc6tDSMIClzrUwshyR/hV5nSd0Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-ed/97KH2jVc0oedjN2EbzkMpiynEMr6YEhQWvGE0NKugdGLLR6Z72b1NyImy64UOs2FZX3zWg7tBBq+rDwlo1A==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-LzquzSN4IqJg/EADkUT8l+PCgGyuPcb2K80Oq9MXSgAEVCD2SRd3GepER785CpIlZfeXQsd4lsaklBo7GSoTBw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-IFge3TxF+cZHd1z2RPokKpGiqNtSp2WtGza0HX9RYRHewP0hARf0d3hq1bDQAMLjJxf8mvoakDoH190dyXQITA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-0G7roKbZ3URRaC+cOLAGkGADaZpUD4AJoYJBVnaH3HRsizbG7gASjmLfEiN6kvMnJI9Wf6K1f2yXVQeBryIzdQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-oWghxDXOEcNSUvjUuH+2OfqT0A1+MWf8YTNwMgRsxKQR/1XFtKthjR2oNnji7Jy3+2Tigmh4qeOOqk5VFNWeIg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-AXyNqsmO+buzieRznlOThn0IiFWyTKInH9+7yq6EceZUFBmEanPrgKDZAOxqSjJ6wtOPo4vBkKhO0/7JB8kOeQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-siYdx85ZKIejQRsVe2+kQi9b2u1/6PXu0meoCoG/VQdl3zVXueKCsZwZne3yCou4lvxX+PnnGkYXk2tr9vVf4A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-bOcl+8cIvTOtlYHJaHA9A5ebYma4XYjv2L3ziW+gG9HTOAgJjs82ql5RF7yRnHc/dPfvteeAOQzmaNJYFA7yvQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-nRq3fnqsD3vc7M9GewuY8eX9spFG10t5NbrBAwMZ0EyZXbN5oj8oX+O3croxGLvmED9E4OhTY5Fn30EoKTnYMQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-7uMe/dvlcUoQbQ4U4V1esj2kdzR+d2G1IDqW7PEO46Je7alN9dGCaFjrYfg4H16g2p/nkguqregXXt51Nv2Tog==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-65sKH2vG/00xutyEIPB9exGkhpG4cwlYvkty6AdI/2g7Zvfke5WT2UW2aME9vVEmB4Zn+gNDTaRjRyFVK3n7SQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-wAhZFtY3E/JEIfkGdX/P2MzYj09G1tDrPi4+zaCxFjXzgcxfU6vLPNzaR/EMQb82ibluhiriFTG1aeCJBd2qpQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-ALDcdrSuoBXDekpuPy3J+RS8vu6d3vt5HTaZkfT6VpJGotv9qq7cvm6kZ10VfFmZ//UbC8LibDsJk/jbzGf0LA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-2MkZiOoWMIBfx1a/lN3Yz4qWszpjkynS6LR4nT89uCjk4riE+xpx2JQb5FDxVfxLFBoYlis4wyMmSrqLSd1pMQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-7x0L8WWLcShkEROnccmVsvAEB11yfvV21lngDLlgWPKH7b/YBHjziS4rlN6pzuA1xozViQkUByyiRaMIwRm4iA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-kl/eWcRGhOnIFhwPexi0qRLw2x/hV7SNkX9FyasNUkYi/6HwMOBViB7RnZe1iV4NRZF6153Nv7Z949/DkUFb2A==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-LNwqyHG1K2o2olSjErf8m+O6vxh3iPHLu05s4GRDYjyUz5uaunEwKVi3m7Nj3EmlQdxnfrpoLH3cfXuA7/mNsg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-1YxkbUSrVZXo2IXlIrB0z3B0wrkHtgIcVn1M+7b7qM0Si9KGFkZzsI7T2X7CQwW01jpRbv1NcQW8A528i1DOWw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-Z5Rhv4e0FljV3m+w4F0Ek4SMuRMpvDs/tsrYmwZboj7KAECrQ7PXWee93FbcecK6Tu64ZtvsU8fkWmffRqfp+Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-McSCf7ELjtNy6gbV2EFU+D1XEi7lw1xI2eqv8VGqX8FyOHlC1nofhyb0PLd7OQLelQpR9Xajv1JuhzUtPkhgPg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-RmJ88+HJ9AqPIMwIlJs/Qujmab64997iyQ3kKdORrFIezKd85+zKgHbnM+CUbxAzqpBNufECmhWm7oXMjyoPTw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-ORvugqCwtaRhQ1T9v9LPNI1TO0R3WUYsCyHPU+eBSmoesTql5/I6fEVqyuRrKGf94PlJAyY2w6tSeluV45B9ow==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-sK/K13o1GY/6MWR0ZrqhhnG9wXtZSISTSXOo8hA/SL/OXEyucXlXyxgXaF5bGtwnUjgibObA5B+4Z8RJlMal0A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-um50+EJ40pHY1ufx5lcVPWjl5eWfHF8Jg/d90XMRD69R1DJ8oOhPTWYSlia6F1AWyW/DQ/ncf4SphUzLNFpdOA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-0OuXkUPLTxK9aOijYilEOvJI/wAA9ohXy7Y10tRwaNX70oNkUA8C5VUuW1rrdMqhrGk1tLaE98DrN9IXXyP3ag==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-B8T4TBq/pkJxzqC/GgJ4UmV1xEeMsLjnnyeaFWXfN06HGrlIumFLR0GQu5PFmwEDjgS9m+sJ1m2CYP3FGAeaRA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-46d5U65sw8Qr2qXegWUtZ822g+AYLGMNo+BVKnU8xZQNyom7Kib0bFHnqJ2b0vQtYP/Z0tEhOvKc7cwu1Yox4g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-RdNmEOu3U0aPwLKL0mTo48/Ou9RBg/3lVcp21iVQyqDmqRBJSSWnxzPwqQURUvY8GbYb//gSezJYBll4BgqgRg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-yDZ/fSQckLPS0rsYRBMIgAMcm1ZJspToWoHrM2OuMjkoZU8JPGebekOAmW19EsAz9NzEiVoAae4vOVCQSQEWAA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-OEb/13XW+yXDYWTZIV9qspJ/ahWY5j7UdJo+vuwW6VOxHv234ZHHh9jV6jQxFxkipaq7FgtWXUqk4oBDGVF7/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-Le2dxO6rTOvCVdWoITiMzo9H8oTWqyOHW+dvU6dXNVVNHnM3N40ppXKaDjA7jhFc0kJUjrTj2anQcdSFdmgUzA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-G9CQRcLF8jfnqWkqXdrVTGO9Z5Jie4HTJZ0MUJl9wlIbKT+U2gPQq0PPEHOtPkbuQuJHyxFg/v/i9Dy8/v41QA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-GHAP5bqAaWMg5SlrQNPJxSsCKM7Wc8JfFBDxJKdwBFe+zb7WHJdk4cNftM2HKlM9aFaljKVx5zyLuky1yI8fTw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-grvZytFhVIuIOicS6Fdbf2YMqZ7rZ8TbIac4MBeDDlTWkCO62EbL+lUZbUStHnmnDdOnkOa2OtNsuCQCKr5ftQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-EciQy/vlJDOXBDDvCiMfwdRmrqL8p6K5DahT3cjJ5R2g0vVDQ9M3oEUqjQhqIhNZddL3EVqaAIr/JVk9DW4NXQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-lBu7jV6lNTX2YJ+sNh25yvQh/15zw1vrzMZy7zypuXi7dwy4TNCf1AyJzc4YYTpkVAsQLStEofQhZ8acNweY6g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-c1BeA+VI35IumWblDAB7kXHPTWA/CBexyySFbT5MizGa8tcjL3RPr5sYctyAN3wQ+bt47X1XpWxibBzERXj6qA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-Pa2P9F6OZ8GTmGk4hPqBq0av9r11gicHEteG0l8tV+8vpvbcwFGDS04dYJkDehoCMhyDpVI1N1h2oEzN62bSGg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-Z2Hcf39NRB0bZwVZ5y3Wf8ETRkGCxkCjh9VpNlHUctWxYzGkGi9/Rei6wJNVh/XT1zhyN5eh3uH8SukbfCErzg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-mzXyLP0VOi4QTII1lfVoDx/vZ/1SQD+cDsjjcNDdPLr3ufptEg2j2SAFnvKyurOnzlbnZdO1ogip0VLGYUFnyw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.0-rc.1.25451.107";
        hash = "sha512-7vF41HU0xbpHBA7IX3Fs0HtKOgtXplTIkPWJ1FOpDxjH/R6xPCWxv8sRUNeh8SGhs7mGpf7rwcDGIEIapVLcBQ==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.0-rc.1";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.0-rc.1.25451.107";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.1.25451.107/aspnetcore-runtime-10.0.0-rc.1.25451.107-linux-arm.tar.gz";
        hash = "sha512-gQWKGGYpZ+glr9syJBA/2xEc4cD8MDCFfGLMStHHAW9JdH1zPXWM4eyoAXLeJmyBEmr4mB6+HA1d9yZGZPm2eg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.1.25451.107/aspnetcore-runtime-10.0.0-rc.1.25451.107-linux-arm64.tar.gz";
        hash = "sha512-vYa6xIQFCE/sthAmDmCh9kXeRV368gjK7JdxrxYP0de9yZpKH4gWnBzvdZVTbVXcVxRyynoVkoJx1ArkX97e+g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.1.25451.107/aspnetcore-runtime-10.0.0-rc.1.25451.107-linux-x64.tar.gz";
        hash = "sha512-0iGYUMq3POvjYlo+UyHGfikh07/vtsI4BEoh2KlcoHynMVB7p8AnqLA/6O66fyPY2ITTTwJDfWpYMEI0hAU9cA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.1.25451.107/aspnetcore-runtime-10.0.0-rc.1.25451.107-linux-musl-arm.tar.gz";
        hash = "sha512-AGgWPjB0ejP5EVLthi8okS/4A9rxK9kVpS/rL/0GqLFTwMidnbllZ0oR/9ct8rE8uikSTCqXkL3jjWDelxrNeg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.1.25451.107/aspnetcore-runtime-10.0.0-rc.1.25451.107-linux-musl-arm64.tar.gz";
        hash = "sha512-0w4mUoypPzUn81NduD4eGazxLXhwj0si9c4pdTS0fYMHqeNGpYgqrxWfpzuATN9x9cWeLtOUjKuu1cc3kQr7NQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.1.25451.107/aspnetcore-runtime-10.0.0-rc.1.25451.107-linux-musl-x64.tar.gz";
        hash = "sha512-hs//dBAVHciEJ9C5x5UZTnnYE5Ya+SoCYE3UenPIemLMtsvf1m7824oQlu59FTjFNfgBbXZ6Gbz3jM26vs8X4A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.1.25451.107/aspnetcore-runtime-10.0.0-rc.1.25451.107-osx-arm64.tar.gz";
        hash = "sha512-4erPMY9DFFB8uXn7jw7ldK1FCumPa+K8CzXcSt+EeKq0vs1q98DSrFaCundnoRkKT7X8mze2a1rTYmBt2YGk1g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.1.25451.107/aspnetcore-runtime-10.0.0-rc.1.25451.107-osx-x64.tar.gz";
        hash = "sha512-XWSTyx94DCBb0hjJmQ7p6KvES8gdho0ZYEbWj/MN8LcHJe/67i7jez6CrnW7DRoUtWwKOWQreubQp1LGvJ6piw==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.0-rc.1.25451.107";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.1.25451.107/dotnet-runtime-10.0.0-rc.1.25451.107-linux-arm.tar.gz";
        hash = "sha512-k5DvoQVATX3xd52jDNO5Ufta5oFU4dzqKA9BclduVGpOJuEWgqgHi4N+CWWoDgbqxdrLtWzXBFpEzP65AdJisw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.1.25451.107/dotnet-runtime-10.0.0-rc.1.25451.107-linux-arm64.tar.gz";
        hash = "sha512-jXbk5mWvff26Xkoxy28buxh7wrm43lZe9e1xV2ja6FkSMEKvezhHZAltDLiaPWCfnkm8J8Ip0sEWVM1IiJYmPw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.1.25451.107/dotnet-runtime-10.0.0-rc.1.25451.107-linux-x64.tar.gz";
        hash = "sha512-v2t/ca+OsG6guof80owXgiLQ/JOlscqTZgA8JPyvvcSXs4gJ5DEKl7+wT9J6C26JLnbo1AP2AY1vyViMajgXDw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.1.25451.107/dotnet-runtime-10.0.0-rc.1.25451.107-linux-musl-arm.tar.gz";
        hash = "sha512-GXH4Fi6PENK4qKMT7s1BgF00kdKHLGIrzxhdnBf+ghg3CvAhkg0AKXnOa7EEO/eg2RPi8nNG1kveoXxJmTWVIg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.1.25451.107/dotnet-runtime-10.0.0-rc.1.25451.107-linux-musl-arm64.tar.gz";
        hash = "sha512-KU3/OCc6q1Muqu15ATmRJQkGEvIfjC45OIXGG2Saq/WkzLhQ2GYvBI1aIfNb8wArA+AcVJd0d6NRkAhKbtJfWQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.1.25451.107/dotnet-runtime-10.0.0-rc.1.25451.107-linux-musl-x64.tar.gz";
        hash = "sha512-FHVFTKpRnNOvpr+3qVF1B8SRTFPQp5KO9/XTQqVr2jUaUL3ClCT648tezazSPX7zwYfdx5kyzKRjm5qkMbElbQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.1.25451.107/dotnet-runtime-10.0.0-rc.1.25451.107-osx-arm64.tar.gz";
        hash = "sha512-2faVsHe0g93Wririe3Hn3hY5sR+jGQVIKhvJdXSHrNVL9qR4FrAkQVjZG3ZCPFQsaiguR3BaFFJXYergsvpQRw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.1.25451.107/dotnet-runtime-10.0.0-rc.1.25451.107-osx-x64.tar.gz";
        hash = "sha512-XOjEkl0dL3D2/NbRpP0AH6wFowKWElGaHpbNeE1WmkgT6PHIWlE463WiLdPE7C2acEZciQQqaFdqeWWZbl7agw==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.100-rc.1.25451.107";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.1.25451.107/dotnet-sdk-10.0.100-rc.1.25451.107-linux-arm.tar.gz";
        hash = "sha512-SnuClIY0v0mB5HspK/xPlAeSWTbqc2QgpRrM8OzQXG4aqhx/+UDvV1CxHNe5AkkLii9NpzDtcphGJwdR860LVg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.1.25451.107/dotnet-sdk-10.0.100-rc.1.25451.107-linux-arm64.tar.gz";
        hash = "sha512-calHXMECIFjzOR7vhQtRhEDS4TTeY7HLi+BIqw3NwTOSiMVlboBrEJemA/0cJl1OZ3NZCCYRRiSC7kAvr/rD0g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.1.25451.107/dotnet-sdk-10.0.100-rc.1.25451.107-linux-x64.tar.gz";
        hash = "sha512-uzS5PVriMQHmd0gA1hJDwjatAfJ7IqFnDZh8EGjOB1YBtN/VITIKclplS2Vf/ZEoeLL8hDYXoLOMWmHzCkzSnw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.1.25451.107/dotnet-sdk-10.0.100-rc.1.25451.107-linux-musl-arm.tar.gz";
        hash = "sha512-YdcnEuKVJQ89I0OvqXvnwnK34pIn3Prb0G2aR+wrhxWNOi7B9VnpiZekz3mlQQuFAhpmkKi941BnKEkmsjQusA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.1.25451.107/dotnet-sdk-10.0.100-rc.1.25451.107-linux-musl-arm64.tar.gz";
        hash = "sha512-/1HV6qNuFkmAr0f5nuX2CbGf188Mr34WfUDG8wMkByshdhUo8mbGuSHAfn+sIkBwHn0bmvirVIvNBdNyCKpVlQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.1.25451.107/dotnet-sdk-10.0.100-rc.1.25451.107-linux-musl-x64.tar.gz";
        hash = "sha512-zH65o01c6pdXkRWRpFX/IJDTIcP/XioWyBGe3+0Tzn7/H/9AgTTYtaYr/7sbiH6mzLYKdJd6XOd6KZc18J4Ciw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.1.25451.107/dotnet-sdk-10.0.100-rc.1.25451.107-osx-arm64.tar.gz";
        hash = "sha512-Q8Uy7gqgPwJF7wVXh4nASCLqacOOhS9XuwobSzR1D20PjHeghcTrDWEwGPg2dK+5CW6Z/OZoqHYwmKvoIbm34A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.1.25451.107/dotnet-sdk-10.0.100-rc.1.25451.107-osx-x64.tar.gz";
        hash = "sha512-k3DDv4JJjXPBc4FCN+zhCMIHWOhCk+dlMoN9h3vn6+mqinL/7os3G7wKzqokEQ03eHFTIneKQhWb0ykQ2p8HaA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
