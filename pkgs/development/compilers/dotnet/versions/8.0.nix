{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.20";
      hash = "sha512-w8Q6dYKAxAkZXJyw6WP/eRUQf9yCWIlM5ygiKcbAODA/hVyo1JCiWQ896c1G1sy7wa+/3Q0vE+HkVFCNvcTfDQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.20";
      hash = "sha512-ReqCsIPouP9rnL6Xrf+bmZujKQAnTk/rd9iIQhrEtwzKNxbfwa0MhdUo6D6oUiJXvVsRJbrn8aRnlCJfAXFwAQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.20";
      hash = "sha512-bdyPf8QDM104vzSBaxmCN52RMxbs/WBLbunXswNCUE9AczVdlCo2G7SZIimphcnzG0X02CITHiUiD+z8bTFVOg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.20";
      hash = "sha512-ohUx65qZpbiYP9jyu5H66IlW1wfcnUQ31Y/igebwG96EE221DRVKlfZeDMVtKnX+BpNWyzBi3k7bp+N699x+Gg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.20";
      hash = "sha512-EUqSxZh+Sa/wqzUbeFHVtCmiAqH8B+hjGGmTtXB6NjfhhfINQu1nrc+Aoz+6iPpOaP+q3qaAtDjU2gh1IXSdxw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.20";
      hash = "sha512-cwfZXFLRsDXgBqg7+im1mztDSw4bYRR/OVSjnetq6nY5JC7rHiBg6vPFdFgX3B/E9ihEuoCErOPscR4DkwQIgg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.20";
      hash = "sha512-MTyuSFZTIWzf1bQ9U2W/pR7+k3a8pNm+2U+5E/r0pfq6tAX6VghOUCSAPphOUewlCk5MPHsgVa9I9hVTI7I9+Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.20";
      hash = "sha512-4Iz1Qb7MIybAKAQmBvhlEVpZBWz8za0WPX6COTuvcK1ZnJ8YuA3JvzPOwd7Ni6729dEuxEdTVC3Yzs55tvMqEg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.20";
        hash = "sha512-QzpP1LCuFNCVdMF8zxw41t41F0QBb1BOPFcmM5LAYkBb92pvwazmdXpUwl+KwqwCu3XZfLDGLQN1qkCKdgtTKQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.20";
        hash = "sha512-9FVoJFIBCbcHf3IfAbVrKzwztax3Aexm0QMWzwW9zbzKATDkM/7a8zSWsCpCHn9XGeKu2qWPE4pdTd3cKEgGsg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.20";
        hash = "sha512-+VqaO6X2RpIPbqwd0yaoUpxe4gmzOwfDjiLxGsv8f3V1H52iFLkoQAYPqtEizaUSshvRUlm/9qTfaHzRLP9jVg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.20";
        hash = "sha512-nOzF8i5n7DNg8it1yx1oKmMpdn1h+jJYpKLntAbdVuxrCS9vZsSKg3HIDug8CQ1bXFasv6NEhEfefy1IXSeh3w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.20";
        hash = "sha512-uQ3+qVeMUFmcxlS8r40ZNu3YFEz1mVR6rGJNv3JoJhtMU7+dZ7tsG43vUgD4MdfAIpAFHKv9Ybm7dbFK6ZV2ZQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.20";
        hash = "sha512-EuPbJuyEdGCNJS0lvVWzgLGI6U6fsyjc55KhvLJooKE688M8rHAcL+TOE09sG6gKu9u08WleDmh4scBVPSkI6g==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.20";
        hash = "sha512-SPo9VDDJKEY7cOxfTe3JA0wKSc5a7Mg3gPHTolmd1oh6fRQZ3bapoyZerk2CqxH5C/PZ5U8z345klghdOBNI3Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.20";
        hash = "sha512-7IvfZjZ4XJz0bId2SBBr1UcE2+8Lrcx36qJL0ZiGGEYzWF4K9Vkn/IFKOjLlDbKQBVIikDiA8N7WEHZWhWwuVQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.20";
        hash = "sha512-Iz8rwdlyzt6u2aeIXBPD8d+QX4jJKboZpA2ubeS7FkXjABusVQFaFMLbDkYhDOaK5+uaPiQIr8ph5ZfIIjSsFg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.20";
        hash = "sha512-ntG1wuh8qyda0UUamps27EwHMf0EpoLG4GqIkbFMOzgwUhCql2rT4PUlrYQPeQ9hdmnQXL2x0kyFhcJMjMTOKQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.20";
        hash = "sha512-0Mv0kixOTORiDEyqpXpv6MyohFQQGXEDyRp+mzb/XSjtIWxjS/gNpVjuIAf6BgJl7xAldBPGHxG11iLda24zkg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.20";
        hash = "sha512-BM9xD2qHUAz6FTZhaHjdYjWL3M+SNDESboKRTbvlmcIeNu863foCVuceDgk7fEPpoMchFp92nujJ06LZ8CWkUA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.20";
        hash = "sha512-X/ZolZ8ZKsXAe7qxqWIIbtXFqywUO70jsiScwYJjNsRDjQ4iEsafiGcP4sMWSATxJjZx7O2DUhjXG9k5EGxiWg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.20";
        hash = "sha512-eXMwwqnY4cPsuseGoEtuGuxdKPrqDFjy84a4HtbnYTRLnMYDyxd6PZauz3YxKgCvR0tWcousOMoDxSYWljo3Iw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.20";
        hash = "sha512-4fyajE6dozHNiFDhPfeokqO+n5imY6il3eqG5Gi1iwdkf5Nk6ORkro5pIwzYZXkrZFFsSqjxTkjOFzVdg9OwfQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.20";
        hash = "sha512-h0Fk0cjgl/UTD/JTpAzVwynCduv/f5LUgw2KtnDBDTztHyj2xw/zDMNDve5pF7+izVqfqg2Nm1UvuTuQR5HohQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.20";
        hash = "sha512-+xqTx6KQIgc/rj1EoG6xs9mL8h1rV9d7+/3wx/BiNWA9Yz99ua3nc3vBLTj0RvYF3Q7bxs8w3ivHR6WhjqQDYQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.20";
        hash = "sha512-vl1JvrYO7I6HtcDsJRRwfXlNnfi0B0YIg9tJ8kkkGpEk51JbPzwKUUf5UgGMYJYBwCx5VLzNB1H5adYUv51D+w==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.20";
        hash = "sha512-1cX9cT5qBWUHk/LQLuZ2Fg8ovMCXkGU+KBCgNmmJ90g7rJ07DjJV6MNaeXhvK3Mg7uJpIuN17EBHye3EVRIJmg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.20";
        hash = "sha512-G6UpxCxt9sW3mtHtsCQhQJNEIgdLzgGo6BcVEUX6RQNgdfCw6YgGVy5KdN4R45Zqo6K/UVEF0C2ZUVPYk8wrRA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.20";
        hash = "sha512-EJRGxhZBLdGjyTIjOb/fAmDL87ysiFfOc6aMHx5vKPe7kxshjvTVy4Nr/9YXt6poXoeQaDBAw7TWItle6vVu1Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.20";
        hash = "sha512-aW2Fh3+p2gQgRd7tPVgY34+GGPXhIEQJnh20w9Z6d6PtUNXGRaKIcngu6W4LB0QPrHtprsRFBpt3p3yocALFHA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.20";
        hash = "sha512-T5HlmUcha2Fz6U2/9tKLMPp9muJyxbuGsuWwzMjAKFUIrHXErkJxYV9v2gfoj198BHwB8eb3/b31TppxXLIrbw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.20";
        hash = "sha512-/LpPKsVBnxlwlRkkBN6IIDGPMaHqf7opxBNMkjEoU2Z436X9dbmrD8psSx+phiCFvoqaw3X9dn/TqskfFVJokA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.20";
        hash = "sha512-IaPyKzOi6vA9r1OHjgAdqUO0Hf19LKqxhAYJSEFk193uSTsttorcPT8AD/eqRb04rI1T9NiL6RAAvcO6s2wTVA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.20";
        hash = "sha512-7G/+fiuxYl5kS1g/2faF+V+LDW8+0+Wsyf86Io6Wz4YHeJesFocA5hTy2dzBHZ2RXSrLA30xn8kQPnCx0iVyCA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.20";
        hash = "sha512-nBRFxKOGlEX7M/XAjbftd/L3OjQd3kLe68NO5a5y8eL34/o08zeWAz5w6ooLsr/Xb0+33g1Fxx1pwN+kWUjRjQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.20";
        hash = "sha512-lR4xMDs5E5SUB260+61wzYqLM4Fw8WVLOhhpnzDQ6sfCGcnIpAdyywwS6hWn4bTkDbLCUWZOMddahUlz1w3rxw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.20";
        hash = "sha512-g2d/PUPe8FvPmQiFLasrQFJEqihsxBw/iI2C0gqg7bVWTliEKll9fTkO590MHTs2IX7HooGc6OlDPdPgqrP18g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.20";
        hash = "sha512-NiB7rBLXcA0gUjjm5Ayl4xSS/28FWrF69wRPxvX4vfZIaM7GKPoqkPdpGAQRdO5AQsnESDPoXm8gKZywupPRzg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.20";
        hash = "sha512-MtY9IP4p+bPOA5UY2Ora6XUsmOZFZe/NQYycXp+msZmC7V+XIaJ1JxCvb/wZYPSzdj3o7d7wHrp18fOKI5Y8Kg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.20";
        hash = "sha512-SRhF9VzpT8nLEfSixN9B89gi84Cg5CL98v9ZJTR9oQmfzbE219UaXsWxzRdB3kInT6fkP7c+940tpDudrU6htw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.20";
        hash = "sha512-EzCsF0E13D4k3akvyCnOSLXeyKeS4vmsBN8p0h5T2BlDf1jsNnBTdrvO7lBoXpo1W20wzgic33533E7l0pdeWA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.20";
        hash = "sha512-Gub22p6ELMUhID2PkyDJ+31LJqIij58Mauwn8//pmW0RlviI/0fHt0MUoW7F8XpYGsMc7DFDPmczVKBAWWrnQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.20";
        hash = "sha512-NeMgGpDGbFYQyQyDufBkTZguc1N+6uM38qalGsmsc4kXqYY/oa9fjy4YCRNL4NB+3hAtO2W7qP9IALGUPih6bw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.20";
        hash = "sha512-pK1xMLndZf0nTfM8qYoJ+WmOKvSrpvV4qqeiNBgw+/d+mzboCU85J4vLtEzGuYXWIJTKDJuxM7GqJU+scAreTA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.20";
        hash = "sha512-FmeBNXl+vmZ0wI18YOFhB2w8koEWmV47RQKwUZdPnx8lf8tG1aSrRAt4i3wIiSJ+fqcZ4Umbp25s9bpKhp3Kog==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.20";
        hash = "sha512-y1bMcE2NE63Ro7RzoCSkjrQW2TDwKbwZHqrYRjSYhO8E0uq4uYeGSuEjE9o2Ooq049xNdYsdTfSF2ipqFmb50A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.20";
        hash = "sha512-RCpG2N7+A0/ljYpcIW1qWG2YAFU7Mqs6uBRsb51ZCKfYeqnnrsx4rLSjzwha9nc2C/GATLGXdKTMumpub9YRxg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.20";
        hash = "sha512-GNQt2cD/FnvbX9rQa5JbIQxeP10+PtZYxaN9AuhI33RXphH2xM9SAL9sOumSvbxjRwNJs2eVjFAnKMQ7A0Jylg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.20";
        hash = "sha512-VF3LetcpHjzxjsght5M54+RThSbMX3PWpYlUfa8EJiOWRDxxXJzN9GN2736huINuMaVjnwRipfVTc0RAGgiFsw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.20";
        hash = "sha512-7jvFAaLaQzsHOWJ1uhDtiptUFYifuBGHRm1mb4qWvyM8fOlDe0hkVtkV/32IKDECsqU1XkVr7uRpkbQcA9N7yQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.20";
        hash = "sha512-3lxzEUUNkq03eCVfnw0y6T6VPjI0nVp7kGBa29yvYj4gtwqt4fupOj7dFNzjcsHiokoAPvMKoQX8uB64oxt94w==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.20";
        hash = "sha512-iH6z6a8C5GbCTskOlkBdBiRUzO77AbUOdBeqy71E5Z/nbyii90MkG5vaHCFzGg9Xd9y7AAI2vQWJ/tYeU5GHpg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.20";
        hash = "sha512-UJeSYV9ksc6iEFAWu280wxIX2RG26u4y33cjO6IVLDtatcQC71kSRCjKOjEp+34WFsHaAPJnv0tNiiIM1ntx0w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.20";
        hash = "sha512-/YRAHE/55Hdt5BCh0K7//AfyLnVsWQv6E5WqqCrILeXuFu6GIg/Xe827xPLF1SzeyZsT8CwvRLx+JoaK34ZE/g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.20";
        hash = "sha512-r9MHRknh3Dug0E7QMdCy/HsCgiNir3V4si2E3/ya3ewJqtM9zCosCyTXRk60Hy9y+7GKk8IL0UPyxVsaVy7v/w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.20";
        hash = "sha512-zmrrxrQCnBNh4d8jdHAtPYvpaZGB2cspy54sIk1vFQ3sAvtyPSfs5h04lTBactetSWBaBY3Qjzf/hFUno8EU3w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.20";
        hash = "sha512-0rCiA+fx9zQX9+LvmvjKbdKqpAqYrvZRBE/bXM8qLGpBcLyIK63IKBUCaG4CXH9biy1NLG7fSp2CfaI21d6r9g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.20";
        hash = "sha512-kmsMtjMZD0mp0kQqZIWMRAXKDSDwyBdNADDSyc0kjT2A/QXy90m9+fS4g18Fc8XUT/LDaJDCH/hAEnN4/z77Zg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.20";
        hash = "sha512-rm8nD/z9X7KYcYBV4z8mt5QGIWQjkh6YJygK2+Vj3kCy/s1KCNXVoHMgnZ8XrX20t2vC03gpPPK+s1MI0Kwgng==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.20";
        hash = "sha512-dOhLVfBO916TVgUqNwcaw7zTqs67iFRoJRl3jUweVFU6tgKpsiD8kMu3mkJ3wZ4VPFrJVKQ8+CCZ8jyZ8r4zfQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.20";
        hash = "sha512-ealoK3QVdtxWrKol2M3EvRN5PiUNN5PbhSVM3QE4mqxTknorsJwTvMm0YxqP7ii409KlttWLGLXzm2oqsVnkXQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.20";
        hash = "sha512-WEaxn8dvmeGfUjdkmWLVMibh7VRCFn6YPARsFPaKY6hhp9q5Y4qfc7s632igIsfm2H1NFKGaWfqAccD1aVQZGg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.20";
        hash = "sha512-hOcmXXo82VDqnbX+RaBFTXqglvYGxTwx7iM+JmYgcxnlhb1EV5NIWeNoLcEudBCijRgTRufJFAQES3U6s12LNQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.20";
        hash = "sha512-SpmPD+pPVdq/adTKdsnIQIVyOlN+lUOj0ao89HKn93z3GPNr0wPkUPAOKScGJ+a5OztwBCxIBQrXYstIi4w18w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.20";
        hash = "sha512-KNrsKUKMljQJion4qdaFPBiFi+YbJsLMJ5vs44yawMhBOo9NObr7aw0mpYvJG6uhVgerM4xqTKaCPMF5Xc+Y7w==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.20";
        hash = "sha512-JJYQ7liq6SOwcx6Tk0qi09EimH/SS4+qskF/qvzFC9wuJzAzL+rPkfBPZNRA/l7CRaBJ2SYF3Iy/jIGWHHb2+w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.20";
        hash = "sha512-UfD6B3qxSQWT1vcKxPi5V6FwmxKTgOFQxncFyIvJTr+9s7HrSJXieOLicqoO3yqdt/Kzzk7p6wjV0A7neBp35w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.20";
        hash = "sha512-osKzTHfYnmPn3KWbni+S6g3hpoAsI8K1cwgt9q2w+yKX1M7aZbRVD3jlDgGDRqMP4qEB0IiwL9LL2oxKGMpocQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.20";
        hash = "sha512-tl8FRifWfQTJCGijYeHICJm8MVpmlrRdRZSjb3ngn11aUrPT3kUgez5ACfONPuRiGytSqvFdZETs8IQ5QC+WGg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.20";
        hash = "sha512-TTYIos9sWCsMlqZ1d+zuSC8KrGQ5qiDlaX20Z+/PKKDc4IEcEZoHHAHw6HRbOaCN2+Q22h/rPZQZNAZsafwcQg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.20";
        hash = "sha512-1350+8oe4EDEOPOrIq+MjFZ8KiOHmCE9gbLbFq7ELGjbrL1Q6WGO3zehotUUkGm0LkyYV574h624xFa4NHSilQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.20";
        hash = "sha512-wVeihvD869ze+VzQTYgrYVUDGvP/3MHrU7oTnGCFU+9EHIjrsgC0kzV/Br0ix7lQBbhkvQMUlO1PJ4Ti1NN5EA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.20";
        hash = "sha512-2Yp4gHZDcFjP3/Tneo4kNR8xdU1wnVKnlRqyrfoNY/7aGdqC0gT3bHfCQn2Yx2dqcPw9OiWTlQupG+lSOzshMQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.20";
        hash = "sha512-84ttmC61etKqolo6LQNDUutTAPFegR/OfhjjsVRd9Eb4nOSfsj1B+5DrtAZOySdDr4ajEXDDGQZxfwRppD2ReQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.20";
        hash = "sha512-UtAxgEjg4ouof5y4cRcTWVnx13chf5GjUx8tLnPoVvVy4nCQ1vAXz8p7xpX7ynIcOv0+xeE6gB2lqAUrBt6BRA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.20";
        hash = "sha512-qQhPKP9gvxC5amms/hUOZstl3G15nSysUNusJyQFez4mssEMByaggQFcNSJQ7qVdUbHBe8pr7oXq+gqLeRh3mQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.20";
        hash = "sha512-BqGeZS7zLL21E3m9/kFnQJiMa/RDzH5IDxZ6Ie6GqGIWF/2JCrpFQ0Tojdztsd2HOyB0et4f4zmk5NwwJixRmA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.20";
        hash = "sha512-9eAKWh0ctsXZIPyIFj98xnLmdvzGykKnKGnq/wCXDpSl31H32ZPk8ykHvdTsoWet2dgpXDk4QEmkDCQ7k3Jtvw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.20";
        hash = "sha512-ZhhScmWp7O3PQmDF4/P9yrJcbmxRRG5xWyun4/tgQ0tRiB5yWHi4GsEC1qYWDBeZgCWh3R/RQZpfrQw7XDEqzg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.20";
        hash = "sha512-zVpBal6XL6NzaWjLMILvv+xmd+dVgGzJxUkAUANFNzaA2tzaAhUdM+o/c/diSRXn90twNRTqZVjxN2gmHpOorA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.20";
        hash = "sha512-nzloh0qieQdMYcVvdyDGh5mhIY8iX23btA4fml7QkN5mP44bfBhhKEn/x7XUUmOyiWU803ilQrXKq2w1KldH8Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.20";
        hash = "sha512-9FXDRSRDPn7Rv0kBhZcK8vHcXdPsWATa/qmRUYHAz1NOjJmwyvP0mUE4n5RyxCzBXftCC0MxefYthO2hyaHXyw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.20";
        hash = "sha512-xyfTViQUODt2a2Ddv+/43rAx6OznKrdztETIKWojJSKtZ99h7xjRsnTl3wfGNF4rsO+zwwsjzQvimB2qhacBtw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.20";
        hash = "sha512-2Yh4LcGEhJdGywCpcnzSBjR+JdBRfNq40UUawMyEZVCW4agwE9F0oLte1tETd0xBAKgpkLaSKApIyOu0E+zhJQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.20";
        hash = "sha512-WuPzqbeh1mS2QY5urYXIg9rec0pwt6soof/ikSX4B3nN6oE5bG65AwtQH1SLqcIHbFXH5qIWMRHEyorKeXRd6A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.20";
        hash = "sha512-PNwoTDK3fAoa16XlhCkfGxAw4Lh54aMxLN+oADsGtbTuDewjlmClsg29xXXfkXaPVt6wT6dJ4nS5S4QEx5nAqg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.20";
        hash = "sha512-43bjE2OWN9+3d8vAlUltpr3Lf+TS1xNiFBXZCw8PDAJIr80PhWyyKmAUj8LSmFkKRxNED5mlcF/oH7bID2Dtfg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.20";
        hash = "sha512-JefSxGVUpddeKa+vtOiuPkVwUWsVN9IEcbIwz2kLnj/UNm1dWb4Dw8+bvGmrHOieKy1crNb+hUCNhaG1tlEpkQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.20";
        hash = "sha512-rIlOBxUbcuPPgUWA0rK3s4XeTRg1a53JE7cPdtFjBLlM0z+dmeBdzm3WIjpOGu/UKmMst5x5ryoujHLC3dX4xg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.20";
        hash = "sha512-AP9EHyB7ss5643rWAKE7FaRt/SVHPTUEhrKRISd5/HI3xnr9gnsjEUykX3fjVPp6ax8ICPb4T9IHf6/alLJXMg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.20";
        hash = "sha512-YWtThzSyr27k7r9H/7Y8tYwYmrXgfaBq97UWLh8JDBfq+ghlP3KINgyLaTTAW3OIH5zU+ezy1MIhwqM8xZrPKw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.20";
        hash = "sha512-AfmWcWzB58IUuNWMpeAd+otKj0OALXxdZDwLnPhCySVk5/9EmT2WxceiQsXThfs1DxVW1R4o34Pu7HFQF7i0aA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.20";
        hash = "sha512-ew6SqixVxQdEjZCCqpdNQpl7L3/L8bJeaJoiIGidjDRel1yy9xIT6tWytPdJNFe/OJ2TEQmhqUfbHyXt5sa5nA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.20";
        hash = "sha512-S0y77RmklFuJxOqzT6FTFFXSH7BxHzFtFVY/EbdJkEG5XBuj/EgPUJgjSgObZyRKKxxEkA98x5wzddWzXRcO5Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.20";
        hash = "sha512-OT5q4JyXX7Nr/cy5jMdhAVt8NjgJ8/73Z/3qvWjz3PxoGgo1Q11gbS/h6COascUcY3URJOgwObkZ7eu2vseM0Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.20";
        hash = "sha512-Yvidrsu5zVlxXAO/H/ybtAiipZHLZZSWeKZGfg6YWNsg7KuGw9hSQMe18PfuhWaYxzvxCxf0cA0jkA4ZOOVm9A==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.20";
        hash = "sha512-ZutvBMofw1MJ+9OG+kRmySbLG60y3VdFcCuqmEspF66qquHSqyXznz7Ex4grpvw4qyp8pZx/v8M890JTQZTyug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.20";
        hash = "sha512-PQidh2wSE073ZaKjf85LWQ75w9kuLMroHyJ7NWXUlIptHC+asUbHDUwUYHSilOYeTlNMxVeKcZ6qJ1zG7ubCJg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.20";
        hash = "sha512-FJGlsipj+/8ywOfkYnzimVWx3qSTiF6nsgKT/ysdeypBTC4YqRjc/alJksMRjOGLvJ/IWGfmbhVH5UTFZki8bQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.20";
        hash = "sha512-nRJqYuX9OC7/S/SD9tSqYdjVJBLDpzOuzJN3r0s0eYn2xZYfzGqZqR1yHus1FQKnDECJMUlQXQ0S3PcXcel1Xg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.20";
        hash = "sha512-qnSGS/vF3E8/gOxdhm8K0faqm3ldaKPFeksLzQRTZFi4o7Bi4AHwUaa7DK4JmRQZdATqJxXhau/JvvT02Gckzw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.20";
        hash = "sha512-8LrbEM9eLe18sAIWyWi7M3AAmjh05lZ7XkX6MXFzYm6zVJJ39E346zCGaTxbQ2NmoYv6OYN2Vxhz2Fpqh7wEVg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.20";
        hash = "sha512-TvXVK/2GINdFnI7XtkPRmLc4E7dBjUo4rZjsLb4CNzGz3D537cONTDDuWxjkAxoCacAbBi8MKLviPAewTo12Qw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.20";
        hash = "sha512-Z5s4bwM8OTiF9JU9wGu7j+3AO/xmt/UqvKR1zhw7KyeuzxFdvGRFhg7Jd0AfuzSrlFlu+M1br4mEe4Y3OAa7WQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.20";
        hash = "sha512-iFfqMX5CyeyO0ZAkN7fwQ0TrOosiPl7g4CzNIswHurqho42akKt3n4z7NJ4oJXSuE7S0+QqSuT2uEXCBAdGs1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.20";
        hash = "sha512-thAg1upqdp0FI0TdG0XeHbvzTvKfTB/bqr/U8eDN6C/hQlqzyTinvv7A9KDzUn+RsUIMr4WSHKsyO+VpjNntfg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.20";
        hash = "sha512-9u88OqkWZze46aWsltLwCd8kZ9H90wjk1Npq2rNzvS2ZX+PzG6+c7PeRH+19esBREB9ii4E/Y6PnD7CqmLmxGw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.20";
        hash = "sha512-mdH+zdMoAcKWJHr/DRktxkDHEjhcqawma/+vd13IQsb/L7Ogt11c4ko3dQK+r1FnP3J3L0AX/NfpdzkFl/1kcA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.20";
        hash = "sha512-Ajwwi5j8c370lpsBBFkOMD6G7RXwCgIRquEuUoYSfskfL6TNu8P84KWx9DAdEZyDR0djHOAYPRI0a4681weGYA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.20";
        hash = "sha512-bScjeRSsoRSxW+MCnggiYaa3FNM8En4pnAcjIx41GZTof0sAGCA9/8ay7kf4+zXDPJFXBb+EBwGZuzVemMtY9g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.20";
        hash = "sha512-cyjz6KHwDaCvpLR1DM9JsJB42iCvq655XojxuXb4Cfi1I/fJ3eUXvTf8lv6gWIkU99m50QhbO4/ZWte9+s4ymg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.20";
        hash = "sha512-jYFR6eljhQrhg5rDRzJ99SR4PyM/VVMvHSx08bTw52PIdmBLoVdwz/kS8XTfsJiRyqI1pBOWOCAhIQK8sy/EMA==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.20";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.20";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.20/aspnetcore-runtime-8.0.20-linux-arm.tar.gz";
        hash = "sha512-GI3R8sTr6JMqoyVInQGSNlYdIhkki382gBYJtCPOzPa1tv+vDtNl+xmy2gtUN4tRRdnoevXNlfpG+nxZXzy+Qg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.20/aspnetcore-runtime-8.0.20-linux-arm64.tar.gz";
        hash = "sha512-F7AdYwmJnupAIA/ESctgbfVUHFgCuXPCHnHX9VObcss14trzi9nhfsbcz7I8PBev2x5/BfsT8QcBVh0uALGWRQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.20/aspnetcore-runtime-8.0.20-linux-x64.tar.gz";
        hash = "sha512-IocT88NgDEnnkk4m3IYRXJZ0tTCLRFFKU/Zw+nhQOKqIXq2M0sHBhQ0VZbaJqVqS6X9HLYZCmTDb+xFKpgIOtw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.20/aspnetcore-runtime-8.0.20-linux-musl-arm.tar.gz";
        hash = "sha512-y2JY3VMirftGTz0MBVNPxP0+LAm/+d2E62UiFh3nfqYHWslZ086aaQFRT7t916ohcp78OgqaG0AUDBG3ZBrL1Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.20/aspnetcore-runtime-8.0.20-linux-musl-arm64.tar.gz";
        hash = "sha512-8Q4ZN592YR83btGbcB3MKjQHzYOlfYBvmSkpWpAVP6KPxidA+OXDQJSpVeg0pwS/QBsJk/JSig7i9dnPh2F5uw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.20/aspnetcore-runtime-8.0.20-linux-musl-x64.tar.gz";
        hash = "sha512-dFje2NJ1SZ0Bkq2olrBCUBgwwsKYWVgeLi2x02u8ZSryLzACnQhmIM0cKnJpq5TQ69lOK01ZkJYomUbvOQNRMg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.20/aspnetcore-runtime-8.0.20-osx-arm64.tar.gz";
        hash = "sha512-79IqhUjjfn2fAhTFrG+TLEUqMDgHlow4xbDgQzs2rUY9V1Be/pdKzv4Nk164br2y9xCqmnQrf0lYhZ5HW0frxA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.20/aspnetcore-runtime-8.0.20-osx-x64.tar.gz";
        hash = "sha512-U53FTV0qVC1W2loz9KNr0EyvA805P9xxD/82ES2cyQ0f1fcOE0uFFVAGS8AKka9hrsL/SZOrh7F8Qc63XvG18Q==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.20";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.20/dotnet-runtime-8.0.20-linux-arm.tar.gz";
        hash = "sha512-OhX2U53Nqx2JZeI+hSrymYrYaN3GzubM1GCnfZ2hjfgsazcw8zZ7kLH3A4+T1m9VMk5e/Q986l+E3HfXVjCy5Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.20/dotnet-runtime-8.0.20-linux-arm64.tar.gz";
        hash = "sha512-WP0Zr+zl5BvvDsrxUQVNdH0T+Qjzpifg/bc7hf9Au7XSq6hapD7gbVFblZHLzdT4esG050kj3KiU35t/xZlR+w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.20/dotnet-runtime-8.0.20-linux-x64.tar.gz";
        hash = "sha512-S4ARd+AJ7HENXiURUAqmC+yVgRrdUP3FmwClxIaEDGbwDEjycs96L4Ep7RWOxbiH0d1gWU5hL3SbpI/PSK+c0g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.20/dotnet-runtime-8.0.20-linux-musl-arm.tar.gz";
        hash = "sha512-A7oEEe/iG6JKAJo4CpiujBP7knH2mmCGuLmGMD7A2FCWfWy2vjGmn0RakyI+MYfm64nvf3PmgvDc67ZUw8Fd3A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.20/dotnet-runtime-8.0.20-linux-musl-arm64.tar.gz";
        hash = "sha512-MhS3znevvLh+W6qqS4i+7VQ9vF8s391ytkccudzRvzxWzGfeqaIVDTDeoO8MWFwEnbFyQ9nsYT75KFCeudZLTA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.20/dotnet-runtime-8.0.20-linux-musl-x64.tar.gz";
        hash = "sha512-l6bO7rPRMsfPKjyxCSMEwCULN2yCylDLCyeJ5888XgTqJcZkRH+SZtoGDk9XP9un7XX8V1lhqIOqMzD8x5XXuA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.20/dotnet-runtime-8.0.20-osx-arm64.tar.gz";
        hash = "sha512-Racowrq4laEPg2p2ne1IPw9XIAaAIPw16QJw22wShR0rqz1oeb8hIrTKGMCvwqV46gwVJ/hIPAVymIueLyO2Dw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.20/dotnet-runtime-8.0.20-osx-x64.tar.gz";
        hash = "sha512-NuVPrATi61Gl7IYlGXggAAc0EAPN000hKW5LhsdcX9Fsux+FIte7VX9Rr66F53RjT6mkfdlQzxhYI24tjJxufg==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.414";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.414/dotnet-sdk-8.0.414-linux-arm.tar.gz";
        hash = "sha512-NijaK5Q4ytWNO9/Ra/3Uvvqbdl2M+/HDltKaKL+ZEw9Y8tsWWPyxbQTCT8vGEHjF1RANvm6g7emmJzJlXAaviQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.414/dotnet-sdk-8.0.414-linux-arm64.tar.gz";
        hash = "sha512-IQJRV3BfZ8nUiXr2as+JlaszZxu27VIRf4ah282qGvsEWcXnFBzlyGOvcXOL2c+eJwo1ttQDRKnoMAtBwd8D7Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.414/dotnet-sdk-8.0.414-linux-x64.tar.gz";
        hash = "sha512-vfaxUfeHrFfTk+Yl6Lj8jhmsdZAudiJ9pzbyDgQs9/+Yv9GmZpt3/ep7/meKDyMQPgys4duD6a7laMzW8bWyZA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.414/dotnet-sdk-8.0.414-linux-musl-arm.tar.gz";
        hash = "sha512-zVdA2yF3ijrCNcOBXkG5dynzgtNUd1hpB1occ49zwNHJkU5gnEqJX2Nc+3E2xLhdca3DapbkXGnPH9MyDqUqtQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.414/dotnet-sdk-8.0.414-linux-musl-arm64.tar.gz";
        hash = "sha512-/F5yjOvPhSr3eBn7y8Q8ps2XRtM+YeP+XQdI06Z1Ejh7851Klxg+Q97f99GwiU4p8XKt94Wn9Pek3KY1kvLyBQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.414/dotnet-sdk-8.0.414-linux-musl-x64.tar.gz";
        hash = "sha512-QpoGAT+8bPVezqfrxcQps8tBXILuuTfavX9G8ChxnFUBhfOMlzIPCCXPW76awHp7TSK3DvQnJh8b9oapjRiC6A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.414/dotnet-sdk-8.0.414-osx-arm64.tar.gz";
        hash = "sha512-jopFLqouKBlesbsz4Nm/8x4iPkfQ+kdhujOaR6ZzbwAQE9wSFpW1gIg4RZIePBFR1f1Gk+vK78B/DWUAoMAeNg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.414/dotnet-sdk-8.0.414-osx-x64.tar.gz";
        hash = "sha512-39u4+RJKKWRqVTQ3mM5mdQ0nxevlPbHtedzE9fF4X21LCliCAsZSd6FqNo12iMmokSL/+qqDzZRQCkc5XvWE3g==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.317";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.317/dotnet-sdk-8.0.317-linux-arm.tar.gz";
        hash = "sha512-btSKmf2qXLgCVt4kP5TpocDIepIBNBJC6d4NgiKsNHW1UH0XPbyBaXSk+dGkiuN1ywqJW2K6ihKWNQ14Le2JMg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.317/dotnet-sdk-8.0.317-linux-arm64.tar.gz";
        hash = "sha512-8XZBfZPjhz0QGiL7nbnMtESwGFnNG7pl6ZHHEADU96R17gzHIKHgefnmBauxkO5/RcgJZQO8/cV6NHIUtcopUQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.317/dotnet-sdk-8.0.317-linux-x64.tar.gz";
        hash = "sha512-F1utSZ7RQ3TePWcm8Pog0r9dlLIO7V4OA4hkfXZc9KYYPiK/VZ4h719ffWqn1G0gxwjaPjhnZUOKIwFKozSMWQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.317/dotnet-sdk-8.0.317-linux-musl-arm.tar.gz";
        hash = "sha512-8dpOUvpyrfw2Aqyobtrt25vsjp0vHhBDtbl1Z+hTxnNhf2hBS9kEUXu1ee8sGj6dbwqobaUlrKxg4Z6vQaXV2A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.317/dotnet-sdk-8.0.317-linux-musl-arm64.tar.gz";
        hash = "sha512-J4WXc9Bw7dAp04WMnk8uxibL5iyxOWumf6K3BDXF0jZkOMnkNTQlRFOjRe616kdvdfl4JnHKrxefKGlxXZUZhA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.317/dotnet-sdk-8.0.317-linux-musl-x64.tar.gz";
        hash = "sha512-lXZZvAC1QjSDbUuX/ciF9UMYDAj5cXOFVxkfh7DCXyrmlCJYpMn07T/aRbLe+92KwSnEn2UXDzhUeZ2maLcLAQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.317/dotnet-sdk-8.0.317-osx-arm64.tar.gz";
        hash = "sha512-/UCk79i8J2vNY5BgB1Jc7Hjt7eBRdfwql2Hr5lgR7jQLKYkKGhZQqWZqQWf8y/zYhBWFMzDnH7ZYmiSsrwvxJg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.317/dotnet-sdk-8.0.317-osx-x64.tar.gz";
        hash = "sha512-wnrUkKLL6u0eIwo6p6SxEhgnRKQ5gFJfjPCZ7WgPMyhAlVrsgN+z9suND4GOgVZ9bo3Sz/LOlCkTptDYfzr2ng==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.120";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.120/dotnet-sdk-8.0.120-linux-arm.tar.gz";
        hash = "sha512-VOUr4dIsQTlGzhcFY2NkgsjLrykFPGk0/jteVdaAwOlZsUWpxTaiTwePwo9Lmi4a39ee3UTtIIvrLUAA2uQ/SA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.120/dotnet-sdk-8.0.120-linux-arm64.tar.gz";
        hash = "sha512-RXG93cvaH9BkIZuM/aLMWLRMvjdZXTePf4E3tajrFsP1IY0JxCBpuKvXox9tdWvI/Sw3s75U3U8Kev4gEroKBg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.120/dotnet-sdk-8.0.120-linux-x64.tar.gz";
        hash = "sha512-IYTw8G5rBj4MWt9iGQ+B8ATGMc+fNAAR4lUX7OsDzTWpTBh2Nm5acwv5M10nNOG3eWytGWQVS8Tcpaunj8Znfg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.120/dotnet-sdk-8.0.120-linux-musl-arm.tar.gz";
        hash = "sha512-M4wFGI23FBB2L6kKuc3oObIKqJ0oD9weOL3/2eFtdx276rSPntZIj26qw4QZRoDrHS3zlKvWwwkyRns4j/P7bg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.120/dotnet-sdk-8.0.120-linux-musl-arm64.tar.gz";
        hash = "sha512-xur3K9S/URIQoUqlyXLrJ1EXbheLOxKfd93GolcBPHW7+iLHz8LcOKLB7vf7c4beJR8xiFb/+3a3ba3afOXyRA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.120/dotnet-sdk-8.0.120-linux-musl-x64.tar.gz";
        hash = "sha512-sRIq3M4ltCP9ezgbuHa6c04ueHrvV18Xp4gT0A2Ypb7ATRG6MPza9gLZ6/HZhUukOAyAdo43cxjhESuI2fY2Ww==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.120/dotnet-sdk-8.0.120-osx-arm64.tar.gz";
        hash = "sha512-d95WUshteRi1HCAUBxDcbpeOza9G4HQWPbR15D2SrClLUN8zQ4laxkgKfNqXUan7HiaDvDgcNvC5Wxu9pQt0TA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.120/dotnet-sdk-8.0.120-osx-x64.tar.gz";
        hash = "sha512-74HY3JOfgDWzszkkOVODCKr5EP0XmP71t8zKdXgYpt/HsjW51y2/Ime1abqgro4kKwhfoKHQOEXLgTzfKRMssA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
