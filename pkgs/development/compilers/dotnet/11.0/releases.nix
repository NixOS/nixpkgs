{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "11.0.0-preview.7.26381.103";
      hash = "sha512-huCRVHfIopNnoJyY0MAJEYzKVwegFElctsTw+OfRXWL827KOFy4PhEl9WexDdLeeyhdOWJlC43ee+3n4Hq4zbQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "11.0.0-preview.7.26381.103";
      hash = "sha512-zWSXvqyjdAbnwNzkPEmt7QaxJIgksck081LBSt0Fs9P0QhK3sKwwJ/DZ860TM/foyNGL04UyXWoygfstXdfgmw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "11.0.0-preview.7.26381.103";
      hash = "sha512-CcQt5WeH5E2f5t/iT8R1Dn+KVZf8XfpMD1lY0l3Qkd3CrlpnDyPWHvJVaQFtaZNZGZflw+a9E9EJvZBwbkbAHA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "11.0.0-preview.7.26381.103";
      hash = "sha512-FlgLFuhtf84apGNI0LcNs7CYBF/FWBKe/WiFi/jcivRd98ZbMPUcRea8KPzLrepHVMf9xUOEAPdUKvZipWO79A==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "11.0.0-preview.7.26381.103";
      hash = "sha512-rx9jpPeCiLGvlI4g5l+W/q0ymD5/p+VEKFS6S032nbq6xIw25oFH0tgd6dNx6wfjqqD/3krTBcB9h+jXFxgjGA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-preview.7.26381.103";
      hash = "sha512-BqOh+O6aQcUX4EoxUiB73lYCIEXKnInV6MlPurzk/yXD4UPWH/QkctNRD1RV0DBuyFngdpX02DCFvPwz3qL3MA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-PS6uA/W7mbSrQVsDItrJMnmW7XNWL6mNPBA9BcTDTqQPpoq8ELzsyjc83qZTLr5hMvyBIeSA5z0tOgkCZnr+6g==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-uEOFYR4e+QZpBeSeFZ0ZA2VRPC9akZ76ACqMpX2kvae/B1/GLNP/AXPlW3Gh9L+Agur0rGTyi+QyEBTJIuJAag==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-z2DSx932GCa/LFHZ4Sda3rqiAd+A6BPnh7uxap+oVeyF7bPFQhXOJWgyk9lEX84JoP6D/6ki5yYBqWIaRL3DfQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-HxPrW/w7s+lANU3oyn9Y2bB2qVwiXE//Fcm6AeTNXAcciVfr2LUgsVg0i3AUaka8Y+top/96mpQ5JJbWohtPCQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-/ruAY9G2Si14TrHhTK9F4n9rRdsljYCKKGkP6wXlqC2ESzQQBhJMBMGkwyGl2klq0k3GSS7qNevEhPjyvk6OfQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-JMzyyuVQepYwlzPppAJZzFg9t9ZSEfk5KnZvkOX94OXFc2+y8XGu5Ancilwd0Eh+26zH3yaYQ8Yp7v92ChzesA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-1J3cr1ap2R77K56NDTd8y9rVzVZ0q2EiG6iHb7t4xKC/1zCJ4fO7zpr/SA2I+9sHjyJnji/yeRCUFjhBF8VAuw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-Py5v4Qjt6iRtuc7zaBgzfKZtfrq5Txe/cyFZxTou3pitTgFWm90X0iGHVegE340WDvxcsOfuWOPKUL5pv8rG6A==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-2VTfPtcO6zCKIfAhAnU3VDaraoiBkbh3CsFrIFz2bDdy78Dgk4BN2Xji+6kQEXRxBRhJGNNRtaIen8j84ALtSA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-Nb+9ov7gW4qqb3o+pYRMccRVVmRtmCdN+f/63IcaZmM+WvxQynDo80keZFRI9ccOmHey8Ul75dCSUzqqooLOBQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-sgsPIH1ZUIPvGVSk+R+/bMS/ISYBu9s6zQHO9D1WP8BrgAnSkTNnjwFVHIo2V90HgnxU4TLYgB/YTn0f/tRgNA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-dN8evA0fR6J0kWbqTUL2WoWuN7llkaQVHsr/EJTgQCtlzSpbuO3TXJIe0VKEUnNa7z7Ak9Nf6IuTNSuKAAJ3jw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-8eHpil7/tJPwil8mFJUJ9JKNvgwfDKscoE1JZbVPRQI8FAutE/Us/6UrAjs6vkIrsZw3ixihLXZtrf3LhigcWw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-NkBvQ5A2NHSAumAY8+rJk8bQhwv0TrsZoKWW+KvxoR6spSj4fe59ZMTAGSDHcdn0Utrbt45uAeS/xXXZiLo1Bw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-dkQOeuwFXCGFtypKUFhtkDwpjgSbdpeC3qQbBW1ox/UgwQ0+DCNEuCwtAPKhHKSlqf8ldf3tSNPgPlSkcvV7Yw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-53i8g+M5o4xCs1GPuARoTrl53d66qnbv8TBiNmkoHuQpp5+hjQRzGFR0RbAvwP6qkrJvYxd2R8SRoXYJX4sHDg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-VagFZ6UTP7sqakNmLJdC3NEF2y7bKJlMFTuPTvY36aRSrAw+7pSELE8X58er5z7DuSJxVfnVOMgWVc6XpCqT1Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-jtPKARAnfUTfyvoF1FJrdswCoI2PxQWHTtVD0MF3jFkFnJCE24CIm1z1OA14z3TJ+df/JceRWXhZ9n8DgrAqrA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-qc3sRphqAT05yF7cydqH7h/SlOjTFqm2jN0SYs96r1Mdp5EJ7nIv9AjRFEqLIgykBkLxg71btUqgLjBT8eKd+w==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-jQFhS4/f2xaInm6qoSz4yJjG59RilfIpsKQu2dBeq1lU4aEF/Z86e+REdZ/IoQX39HQGGjbhYg7+MEjR9lTPqw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-3AAgThhDADw3sFOKxaTQn7sZJJelnTRRTomji0qOY+aTk7s9p5fCFobR9sivBxVM3sPETK3ChD0ufdEcW2e/kg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-inK86V10rJe7DCr+w4l1aR64NfnOD1XIMJZ1pEASHCALcfKwoSe3FyL1yeZlzh8SGzqDohwoIKFIcUKLsneXvQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-7sUHZxAmzkPBfDAZr+GTtbbGrEmIXTb4P9GMP02X5PDxP7Fgg6T/OlBJcg8c6ryTe02ToRyBm7w/aNWOyHOLkw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-4V5Z2ibnMNcNcwN2r3i7U7rcwDMZqHdp4QfOTJYcZg1AhJCKXG3lJk1liYAlC2wKdtwcFP1s4Up49YEGusEHIA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-WW//5ph2A1JvQR9Uxl9gbg/teAd7DGg3iJ3e2R8Q/aH+UxhyRbjJh5zlxQzpBBRhKOrboXmbGN5hqTH95QwNSg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-V5EdCN8qsnQRNWf79esl9QO0nYxLA9zp4Te/rsQfL9NVl72WQk9u4/HkJPBWFqAMOv0WOr6Fxf82ErUe3xK8ow==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-XsFSKqRn0ebfEqIgiJaLNz/2sXWDZIj7iq8t7SLIRClfyUfwNhdri27Gioex9iA63RoN8BQ82iHRnG0giIyTvA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-U274cRnEji0j6lXwET02qkFxKB8IHIkUGGMPgdmnriaOJi4uee/HPuWKzcybzlRNKi84JYBLYhdVha6blvNrBQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-x61fVbSUkD6LORPBdSb1aYCgAsOM/OFSCqKRoJqMLZy4ExE6KRExBqp5/AjElVzv+sFHocHKB8mYV76vsgiyLA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-8u30WHlT3PSn85t4frLvZok6UQIGpHMjKo0/U+g6ISBK+jBJOvr6u/dkIzU45GWIBnmmqisKjNHbamtBQXRKrQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-UTYS8E4KQgB40iNa+wGgJseJM8WH8IuH6MY0HnXOGkLk80eCQHos/hzxIP7lOXw3A5u3aouXeJiwb+1kT1U9qQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-RgxkT7Zfcb4ch3xaBhfX9eYivME/GpSe1YK/4zEaTAyVWgBgG6tv+6Dwjhq1Vvcklj6LL9vWktnhFP20Je5rPw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-YoRJdJ4cxCAu1OjpAvQF/ZlWXxwvtkYmyUomvi6kjH5wEGhXjH5Sb9ThPDhozJYLMS0YhDV1FDCiZmEXoSJrEQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-Lg16KcW1yItrwHH7SZDLODlDzyhJrwcg0hM4fIZZIb4E3nHyP6ozY7rv9S3I9o7N0GkNgY0bChLBQKpNEtBZ2A==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-d+qemr5pOrL4AxMhld3hDmR2boMRGffieSBpT7fuV2pQfhw3AYxgrZ7u906gR+KgJE4rWr18fMv7ODw8h1Ai/A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-kBLGHWLiFRFa8IqB3OKCVGdf76HiOTZzKo/XpRlpGvWigcmYDwWXYf8o/ZIx0TQ9xX2AFGlKUkJk6o8QjivoWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-q44b6czcWH8a9twr7YIEQbT6h9b6PYvHEQvXe6fNNNWNLqTJD5peco65Yh6cKXPF+LCtBo5wX2nNf/wvAh5ctA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-LVsKdrhEK2XsuR73wuXrX8x3A7ZDEZHHz1fY6oI/H0pNGZAb0fSQiMnCtCPW2VyciIBANt0Z3ixM3GZcuqweSA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-n/HIEAXYoeO5mbyKtiNKLMQlJevAwGV+LE1OPmIh8OujLxVGyeIGzBK5DK8Z3AOsOnlts2M9QDB+TUrTHbrT9w==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-nW497LLBy2TPPVlsNK/QlEBT7RHVIvabtJg9myiK6+reyKLTaMAmjm857LB3pn8NBGYHM8BRg+F6UUwtk8DuXw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-ReY4s3y7NF6NrJUkXEXQJY+XrJZBs0Nv0//5YiJdWJwHpcpwlnJhyP4/Mc3qQqkwCLs0q4aAgphQjUxPbf0RSg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-Hmti8+Llah7dIm2SHWPRXt4LJ6qFPEZ4vuia21m5uPyFd04rfjmRqgwVaHjsmq+gb41NpoFcplNpMZk8Edn67Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-ENuNRMzfMwL4JvVVkubDka65wTXORUVmOl8nTh0Qx1U+9XqzBkpJWcEvPLNNmX6krQH/yMCBTlyyco9D3OdLiA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-fT0FDdSsJ+Oz/Bz5TKjbfnWqxyhJHUF5F+k3rjXO1tuJbFJJy8cr0/wvSe7k3no1GcA9LU0eRkYyaVYJIXtdkA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-gG08+gSJr3qA1Jf7BvnOBAatHmYU77XiHwOBV/DavGgDrpdu8A8ZYOIUM1dOp/g6R8rGGvTpcgJUw9F0La21Mw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-H2NsNy85t3PTqfQXmuFyme55Q6FtQYiyMkUwBXWo6PdK9H3bRXaZ2PVDfibO1byWGYgpMQfakx4cRUVtouFm2w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-r5MTpOjKtZCFO9KpsMJAxuEUvJFyXE4G8LllQHY1OiLdhKFL6g48yFr4/vnaa4/ehcZBmKabwoh2H3v1Nzh76A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-N9sj/L4PwzBdJHHsB/D1lQubAhIp/xdexhp0ZRY0E758YVo0A20xzR+4k8GjcryZgm9/n9JADyyOW+n2qsv3Yg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-Wl1pxv1G/vNed1KPYnFlgZSKbzf2zWR0frkSK5/6rtzGdloiQFGDv1ZLl54bqEIUYqYJZPGBa5tqmAV4ySUwig==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-dzCcUzRKzO9lOGWuL//aVonZi2VkgSqi8Abstq5zJwj+nyZ7oCdpoPFYDq1h6cj/idcPA+EqDXXJ7e3MNTfDeQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-8/6j2KMgVg3UM3ZXqHcnnw80HxEgMH7ZWzrP2ww/NCgScsT6y7m4F8Vh3Yu9zGPpPscp6C29aLhItKEC1QNx3w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-4T5/X/OLxPq8hBgDCseXbr0h/IiltnVemijGtqqQSh/EA7ywlNfYh9MVJsvcJ8XPnrChxukEbJH4MMGzJwFWiA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-p8fkXv4bs65zENDe7e7mTgXTBWBzDyf/MJvPKU/gapyk6FvlRrJqSZKsl/bv8RFjIZ2CeN6l6am5f1/mC1bATg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-vLp6FEH9+cfyp4deKEwf6F9py0iVyfYQwuTDaeoF+T9bmMFn0Q390Yp3zlp8v78GF1pMLlG61TWM1i1o+b7mfQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-JZO+EUi4P+Bucyz+U7/m2jyknzcs/4+j7XJNHHjw0/sHkPlmSwsUlOMAW2fUnVa7HizHoBx4enrTE7uO1mYDvA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-3TS0bwyTw2IdjUjcvGPontKD4J0r2wDzcRFa3Of5n1VWn7wFX89qjX1mJD50M9WZ4qpoKgO2Pd5rq4/wojUeSQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-/I0znw19AGnw/XmQAbkdtH8PvBZi7SpcnVnJgzwxcZcWvC0TRZVRtaHPaX7n9QLekmbz8sfkR2iCCoAhn/datA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-XpurbA+JEF+YAHQ2j5mN3Y6rslIHhHRORHxQ7UHsQuIdouX+KlOiQQJlSt8y2mKkAayvaNXw5lR63CxPwf8Zkg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-uPbai2irr+DCOB93v7Ru4/HCFoyDCjh0nvgRlRsjyNJJxJNopn/j0iZ1I2btRD3Z4h/h/B2P0SuC8KS2CNPzvg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-YI9LyG6cSQB933wUW5vLT3i/BeZYbVCOcAPTr+Uk/c2XkiNAHproxAGtEVwwfQgZOjrBJum1J1JbhHiUQ/uOCg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-I5UMSKXu/UChQrG48cCcnVATT9xwhpBPG03z+aIbXUI7pAReEGgYIwKhygKqjn0BSus2Jh8iNBgfUKCIN3g8/A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-/7w5DwjqO8OjCmDRyLKGk2BMk8qa1kiRcFGPL7seS4Bsd0SwbhPRdnCKu5rR3gfPF96uqHz6o4Cxk+Qd9LOelg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-gYmK5cg1s2Xe/wKUcGUPTY87CigjVi4r12kTWuIcib4WPeZQbifZ2wVCv7b/VEhUdI6EOMJP4RgQFGgGBV1daQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-2qhhkTCulhbVE+psqatL570VXCH/jwqzswSCcuZ00a8vE9xFGnU7yGxp7gj4Iz1s2CLui7EDnCswmq8O3s4VSw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-LwJny/UfQcqUtrKas4SlxAWaGoJw21tytlhbxo34a75OpgkwwKBbOWmOogQtrcksuUKgEu0uFonu7JWnP0lYVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-5dfH88QAACGRleYARFiJpmWssiga9+9exSoS7eoKVdm7s4TECOb4pd8Bx6E4TvE7ocwvBf8pE4lTHz/QAGhp2w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-cgdPuTXL2E3FRxVbyIHrZbeQwGOUe+3N6uzUAV5I+jN6Ord54Dj1Mp6X+KUUUM5GruSmn7o0OH9ctPJ6pyM8WQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-YP5T+3km0HSzGAhZbVyTtF0Pe59MbtzH8bBxuVD13nCphZuj6d5B78VRPAkbsITEFZRClp9Yluzk8heycEjxmw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-/AywdASBtOyOdLjpRvvgemLiwPso+VEq1mPwCg50vnZ9LvvkWSVxMlJLk0KrqLn4OzNUu90ZQuWoI+LXbROO+A==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-+uBH2DEshHiILePPc/Z3tkKAUsJ6qwq3LBBmgiOk+vWICUSi1gjiHf7XPiKqaNAPBTJAJyXuMNeGLLwDwBK6kw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-XBSf68edcPuxXLSdj9xUZ6QZ2RIvPfss5rUqgSbSGTqUvJbhR++C4IuBARoMbIG/Eml2Ggdu+TcnF6EmGq7J0w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-VeEAJoDjvQQNNVL9Q/AoC42qCqunSnYPBcqYppqZnsQmc3xX6jK/l/hDDNHWpRHeqWZ2jw4GlAIzauOj7dgqtg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-wbj8NePapuiVPdj7Bz3xXUZOEU8bfKPGFTGfI5EEZo4nGbGeRPEz+6gWvF9+t5RLZ/QMrORg5jZNCnNSvrICgQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "11.0.0-preview.7.26381.103";
        hash = "sha512-ANrPzBV5bSGsvNILQ+3IZ0e0+/rlW8q+/P07gecBGtahz1eLe9wcnNjiotRAIvtQZLwMXGTTdejrNAXARwuGpg==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-preview.7";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-preview.7.26381.103";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.7.26381.103/aspnetcore-runtime-11.0.0-preview.7.26381.103-linux-arm.tar.gz";
        hash = "sha512-lJZVL3HdcnLaipq4EbOQoHJ/4VscOHi/P7+Kf+UAwwH/drQHXNWvzo6cdlukxccTHy0tju0mhuqj5CLYaWeNoQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.7.26381.103/aspnetcore-runtime-11.0.0-preview.7.26381.103-linux-arm64.tar.gz";
        hash = "sha512-yt7GPJIj1XicF//1fEsmNItAt3KwtGGXLPYrJ0OlF4Gbfdjx5Sul2ngKbTEJqjygcY6KmAvfqzxz4z6ImeVOBw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.7.26381.103/aspnetcore-runtime-11.0.0-preview.7.26381.103-linux-x64.tar.gz";
        hash = "sha512-pdi3nz+fmtkVyko7UJmCPKA1EdHJAKgRfB7WuMzB/oQ+Qw1PWNXAW5cd2st+iPr27SWO1wTsn0FKgfbAUyLGWw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.7.26381.103/aspnetcore-runtime-11.0.0-preview.7.26381.103-linux-musl-arm.tar.gz";
        hash = "sha512-oZ04g2m+pv6KMvovmY/OYUgQG4QFzbgJ1QQqJ4PsJS2M3ruUk4OPpT7IuUjjORK1hxnGKY5gFT/Iv9UZtROIBA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.7.26381.103/aspnetcore-runtime-11.0.0-preview.7.26381.103-linux-musl-arm64.tar.gz";
        hash = "sha512-IUB2FrOnrEK/SDPiYHnkcNfejKNAmz/IJKf0UagzL4eCqEQt3/SuDvX5MYkEzyXhhitJZRf3p8kmnaR9vP0azQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.7.26381.103/aspnetcore-runtime-11.0.0-preview.7.26381.103-linux-musl-x64.tar.gz";
        hash = "sha512-3mq47ffknrZRRiWv/cJtyQu4pcy4csI0SSOZu2enJqdb0x/eu1x5+ZlG4GAYVsHU3s4kPZB4ECSFCVkrGzejXg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.7.26381.103/aspnetcore-runtime-11.0.0-preview.7.26381.103-osx-arm64.tar.gz";
        hash = "sha512-4QFAcxUsU++Pry4YyaHN/eOfp5OIhKc1R4LFp3quEXfF9ewF/nVbvwlx8Hklnd0gSRVaT+6hrZLD3u68XZYowQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.7.26381.103/aspnetcore-runtime-11.0.0-preview.7.26381.103-osx-x64.tar.gz";
        hash = "sha512-UMrvYn8zmqQ8y/p0kXoXD68fyWBgzR9udnChPljNvckO5QrkiLLe26A9a0hIWW5du9r2z9cnZOOAaE6h5nWcGg==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.7.26381.103/aspnetcore-runtime-11.0.0-preview.7.26381.103-win-arm64.tar.gz";
        hash = "sha512-xZ7J4NympoBrIzK9FHnJ1OESWNyiU4LzIOpjSQKXcvbLddtZk75m9TsOkNQgvgileBa2SKxoskci3R1joJGC9A==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.7.26381.103/aspnetcore-runtime-11.0.0-preview.7.26381.103-win-x64.tar.gz";
        hash = "sha512-CIEMMN0VRlGCXtDiXHiQxPX2vYRtpp9JIMlg9/ItZTFzYVnFwe0pQS5S8LTy1z19EaaiYgXXDzhpH2yx9cySbQ==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.7.26381.103/aspnetcore-runtime-11.0.0-preview.7.26381.103-win-x86.tar.gz";
        hash = "sha512-TB3TEd25gpaE6UTY5plYv0zXv/LdXsD384KS0lcVyO687bgTvTleOFPSXsYj0yYgrIZSPQA2kFr++YvwXZu5UQ==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-preview.7.26381.103";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.7.26381.103/dotnet-runtime-11.0.0-preview.7.26381.103-linux-arm.tar.gz";
        hash = "sha512-a43N+mVGso4Rk2fEGiK1DP5ZdDHdkzuRIum6SU+weHe+VYGUA5T82niMYJiu49rnh8lvqaMbib95wDeCelvM9g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.7.26381.103/dotnet-runtime-11.0.0-preview.7.26381.103-linux-arm64.tar.gz";
        hash = "sha512-F00JSaQnJzI55dgspdEVL+epyUIou+wyOJNCTpjDzrelafFZpT92QA6LyGp8tLe0XNX7b/58bknSWoryDkqKHQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.7.26381.103/dotnet-runtime-11.0.0-preview.7.26381.103-linux-x64.tar.gz";
        hash = "sha512-z7osIdYxScMYHZj0+pseGnlc2vtD7cwHvscgFJ+utVXNRflelWoeAzB8iTcULHNDRryxZboKBPNFQFGdosjL+Q==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.7.26381.103/dotnet-runtime-11.0.0-preview.7.26381.103-linux-musl-arm.tar.gz";
        hash = "sha512-8xHlYWFbYha2fGHLlZqHs4NxC2S5/MvBaqeiUJCq8sd7omqwqZIqKVqx01ZfVMcDKFEcxpOXTDFz+xAZPLKHsw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.7.26381.103/dotnet-runtime-11.0.0-preview.7.26381.103-linux-musl-arm64.tar.gz";
        hash = "sha512-d/HDZ1Uyeci/W0gSCaxhOz/zm4cfhhmYtbkmrwo3x8kvCVVW9BzNxZp+XGBygKdgcQQwUl27E15kg/HAFevXjA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.7.26381.103/dotnet-runtime-11.0.0-preview.7.26381.103-linux-musl-x64.tar.gz";
        hash = "sha512-mWXA2KMVxdq0Fy0IJp+MHSSNQobxKmRoQ+HVYkSguzBW+voW3iTc6d4v2qU8vRbu0IwL7cj/eOfLHZPIVddsUA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.7.26381.103/dotnet-runtime-11.0.0-preview.7.26381.103-osx-arm64.tar.gz";
        hash = "sha512-NuhSqZgCvPoRnMrL8rj+0A+onyhyxQUw17yivDDY68/MQmLUyP1pw2A3EbRXWVqyWzGLDA5AVFxXONvKTDUgmQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.7.26381.103/dotnet-runtime-11.0.0-preview.7.26381.103-osx-x64.tar.gz";
        hash = "sha512-MMahcmKYRUVBx+3xC9m8EsPetL+2sNmS//X8JZ+J/M3RB8pNeQM8/qeFdNflkgEeDyeb0IoftQOElMPgJqGitA==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.7.26381.103/dotnet-runtime-11.0.0-preview.7.26381.103-win-arm64.tar.gz";
        hash = "sha512-gCtH+B/8o7hGDJBG8mZMZafRz57vlV+geKrXOXKHdEwZChkbXBqedeWrBc4jNER2LSoR7qZOqDETGb+heSg3FQ==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.7.26381.103/dotnet-runtime-11.0.0-preview.7.26381.103-win-x64.tar.gz";
        hash = "sha512-frogefZ/BmwOu8DvRy/ZoNiX+UM9gwsZGfjvxZIej6BkGtZydTBhzAVxtYZuzIJLpJUw7O8JjacZkVNgkr5AKw==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.7.26381.103/dotnet-runtime-11.0.0-preview.7.26381.103-win-x86.tar.gz";
        hash = "sha512-/XgS8glUhI8fuFXeOB/KIkgV3DK94QPUSCIynyPNxhEhTbH6seowctI0mr6lSmdg5sNbjTJIRN8J0TRvCD30pg==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-preview.7.26381.103";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.7.26381.103/dotnet-sdk-11.0.100-preview.7.26381.103-linux-arm.tar.gz";
        hash = "sha512-S2ACWCqak88cuS1i0S5hbme8hypFQlzk3TGWfC/VddsQdI/D5/yTvURqfsXG38yTtBTZ5A17THMv3AMOTF6k6g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.7.26381.103/dotnet-sdk-11.0.100-preview.7.26381.103-linux-arm64.tar.gz";
        hash = "sha512-ITtaSEVUAtvrub10tXbZp+w38w1MbOEJneX1oVP2ATBpdX1MZZeEygfkWshlKblenC/vJs3OlXj3eAa4dXITog==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.7.26381.103/dotnet-sdk-11.0.100-preview.7.26381.103-linux-x64.tar.gz";
        hash = "sha512-Un+dyBBKhiFON+gcfOosfX+6MfYViiPnFFi4WgovulP7LGBqKj5Tondf2uPj0nzWRGN7QwOeVzOVrR3uSzlosQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.7.26381.103/dotnet-sdk-11.0.100-preview.7.26381.103-linux-musl-arm.tar.gz";
        hash = "sha512-5tBheTVoYGFruFe6lzaQxY5UNAUHH2hneiwtWSO1+aBmnX4+CQVhjtfzcp0i1g9fBBbFE/gsaKRunVywVbHxgQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.7.26381.103/dotnet-sdk-11.0.100-preview.7.26381.103-linux-musl-arm64.tar.gz";
        hash = "sha512-eOTlTdXEc2+bbfB3UR6tB0WefWGb4EPZpGRKlU6OG3UezJvep0aSfFv4GhWcionxep9g8Ea7SlJQ8kUVoSnUbA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.7.26381.103/dotnet-sdk-11.0.100-preview.7.26381.103-linux-musl-x64.tar.gz";
        hash = "sha512-+dIpqKsaDp8a4sBeH7G6+jEDu8WV9N1toWhzhRyvM5VCwt7WroNle9nhaxJQZH0RyUbVGax7l5RsrXmzK1EEsw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.7.26381.103/dotnet-sdk-11.0.100-preview.7.26381.103-osx-arm64.tar.gz";
        hash = "sha512-NmiS30GCD1VzL7eGvRCmZb2tXDKlnuJ48h8OLnjKCO0UgxW0ziLEUQbv7MfT5HK7uNaXBlV8TCGEC01k6a1vQA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.7.26381.103/dotnet-sdk-11.0.100-preview.7.26381.103-osx-x64.tar.gz";
        hash = "sha512-vDmClyrY/AQyvWbelitBGr7OKhEpCNRLy2AB+JG+q4HsY+CDw8RcO71IhT8nKMr8R2Krs0LI6NRafZFcuhWFHw==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.7.26381.103/dotnet-sdk-11.0.100-preview.7.26381.103-win-arm64.tar.gz";
        hash = "sha512-YywDQGLU1+RTuC28Y6KIP8xl9ZorYDMy5grNsQlfCbPzrzWxxmkoJjVs8/xQPPlI3/FtuUIiQHiDaZrPBlR7vQ==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.7.26381.103/dotnet-sdk-11.0.100-preview.7.26381.103-win-x64.tar.gz";
        hash = "sha512-VKlC2OqzfA84t7sIynkQDbLOjiFjz+HV0jb/aliOFeXJz8id4DYbUgpURmcZUHFzOG2y7PjHGj8n8Dm73PJ/jA==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.7.26381.103/dotnet-sdk-11.0.100-preview.7.26381.103-win-x86.tar.gz";
        hash = "sha512-DrljyW/Mms/z2TP8fH2WZIch0UQMJkEr/1xlm+rjHGsYnFs8Si6s4dtZU+01fR2a9IrGxHKoSH/A8mASyuBcTw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk_11_0 = sdk_11_0_1xx;
}
