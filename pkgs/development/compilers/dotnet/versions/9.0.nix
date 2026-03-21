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
      version = "9.0.14";
      hash = "sha512-qSgGFleE4ZvBb3DExY0wkNyZtDeGReZMtn+iM5TP40PnFq3246hVF7m7Fj+moMXeLswsC6+6iFh0rIPRJMAcag==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.14";
      hash = "sha512-oY4TEsvQZC5DqjbkzxFU1n8+XKLcmAOEzGGAH4Xpq5iSDTT49Qcpl0FmHat9eUTa+Hkjqh6De9ewzvQIlucI2Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.14";
      hash = "sha512-nBzLKh7NdmLgA3tUaNZmiFrG3g3FtHElfZi7VE5h1VJJlgPiLehVf6iDUDraWSB9sm23ibSV4z2lxxtxaxmX+w==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.14";
      hash = "sha512-1zyv3HlPHpU4St6gEOHzglfJsTWTdN48dtfLRZEw9ruPI9j1cZ5O/Cj4es635TSpz7VnAi10yFVr7Ye6+vH68Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.14";
      hash = "sha512-CCJBCE04eY1Vszgslg9Vnbs6ZS+YxTImTxx/0hNphQd3KUv9KqrTvtqXkjhfLIQK4aZ5yICCdvZhOGwbYAX07g==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.14";
        hash = "sha512-oTVfDmsgrSyLh8NJlIe9tLkw4aCtPSwLUGMTbQTlxAEmeleZXmJuN81UfnkJAdKdG5sivLiQRWwCDG0faBnoMw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.14";
        hash = "sha512-KfRzkAToFV4pgZuiLVXlyw4RbuGYsSAiAvZZQOno6Bv//zX1zTyJJiVcxlJ9fh92cDS8uJz+PaJ/ejhOHs5oWw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.14";
        hash = "sha512-ZkmK4p9AZONSLNNWLuEiWYy8ynGD0r0Fv5m6biZ7oxF8GZNYfF3+YSf6+WQyRSxGlLtm2fEV96DqKJ3R7Jpzig==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.14";
        hash = "sha512-hIhDoJ1Je7kTlBjVaQEa8Ea2v9YNzHFpjTgHTuuE+uXw85mMA30+FU04rHd6ItX7i5oEYR2qfBSe2IvLtvsrZw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.14";
        hash = "sha512-cgIB1paNuwG20tY2h30OJrWH3f2XMGUTf3PH5qUEbM8Pnx/trvofuRhzCcmdiIMCw7uG0Z8fGusOslH2a2u++g==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.14";
        hash = "sha512-k1438qjynTL1eptYrRrmrg1jA2fjz9r0Bk+ltiex9kyEh6+cBbKxn2LaCCsf//Q6WU1sgEBAgJfnrK0hVQ0RIw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.14";
        hash = "sha512-jQy+3YpdZKdohZnPleV0sBUTagxF3R2JE4zxwbw0H9RjiRCIWJA73NliPGXtLZUp/wBRQ/uyb3f6exCgNbebdw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.14";
        hash = "sha512-dWm61FQAslco/9j9JsuwHVL73Id80BPdZbnj3eQCanrML6VfkpLN6qFUZjHVnY8sK32oPO5vXKXI5l6iyfc+Vw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.14";
        hash = "sha512-NpmKObqpu0rbcsinVsQ/+ljJLdshU0itfaLwvOXd6T/Elv+YiaVQQJs9zauEqjXPQzJ4/fQsPje7WwDOUspR4w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.14";
        hash = "sha512-/uABIz7gXDWtRK1w8GLw6BOcMCb7nxjtxiFiTgnEQZuR/rSe9GIfZtYx02xEYPmd50C2IKdijxr3Xl9RU2h5fQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.14";
        hash = "sha512-tl/iXIYlI4kpxftKdZkMzfS0iaXoFS3rZaLjf6n+nhOUPBR3iHfciHRCgClIFBIDkz03PMmSQYgJgfEmb1CIWw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.14";
        hash = "sha512-y0pwq9aOFOTXDT50ilQ1wuv3HTq5kc2QcMRBR2ag7pcZ/A+3egH8X93QxXMIhFU//oY0TVLVp8WITEB+zr7v4A==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.14";
        hash = "sha512-BS0EiLj7JtUJ7i9r63LNSqMIQwVbgvCbVgNDkA3vvhy97/BP1zS0R1hcF3AVZTEiF6TRpk/MRJmsNoYwS7bdZw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.14";
        hash = "sha512-ltQrtUR4/z8hmlSSkV2dU0rBHmAIWNmKmpetNqTJY233SeVjbgieza3EAS8tYMhJHXAGaqjk84Em8qPaemefDA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.14";
        hash = "sha512-glpxsqvwHefKH1cnUUshgCoFDS7xRFjm+O4V+16GncKB/ONcEZIGm8WwnEaRCdqu/Uggsd87x5CJYXI3wIZ4sg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.14";
        hash = "sha512-GVBMo1f82CZW/XjV1zird6w02rfV8qlu/DZtu8IP0nJ+A7744K7Fi6RJNXKJE+C+tqMmlTkylF/mnaxn4UjpSQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.14";
        hash = "sha512-SePD8uQ7n7Q81G2Psvlo8hPbqkFVYhCvILO8mFSvpqOgY7OiiqQj1sBPZKkNhcVU4CZ7LUUOLH7Wv+4gcobK5A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.14";
        hash = "sha512-5jDtZ0QMVbLvdAvnQy3hrkyBC6SCt1Z2o14cesEiamxpeB/gpgPmAqpqcuWMQFyXoqfWENUm3dAPpTeW2pAQ5w==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.14";
        hash = "sha512-6VrIMox8q/tUnQHciEhvOj9l8NfWq8NnYfGle7IUYkZnM21fOqcrmF0jgLWXl48QI/xRVVDMlqg+TWT42jdigA==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.14";
        hash = "sha512-hLN+9dSfcJyNarm8hCHI1R+hDYeufiIGRrr9DfsGN/qrPDyS7awpShEwIdsZ+ChMfdxoYDgnrCV/1PClwqOwWw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.14";
        hash = "sha512-q8AJOVKXCvstKVv/Pdg37mPBf61bFO1u0RoMjksz18LnlQ4xbgzLG5kSILieUg0O95H/rUJ1+rb6dX17fDduaQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.14";
        hash = "sha512-YJaprNxzr6eTrV+zcIZzi9f3wFrjF2KSwG3XvCm5+4vSZ1JFLW8XFQKY/DqIk0UAoEX92W8TJ7ygBXB5FQMh9w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.14";
        hash = "sha512-/bdvIYq3+gSIILJ4R2wdqy4MXC/ZvgbHjQ7jq5fBjUGMiobjsxgab1WRo49Pjc4mGJPLwoggygxgAj5j442mkQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.14";
        hash = "sha512-vKjaQVMP39vBz3CkOpJILVyz+ActsFe0yEvmDOa1EXdR6aCUkpfq89icnlSFWr/oicz9hxGK/cOQgSnRXM2T8Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.14";
        hash = "sha512-GxHFKrzlQ57mYMPXJiZxboJ/rSEecvQgmfvdg7fAnD7c8/JE0AdohboYeCebQEPAOV2R0wEf3LoACUqS3/2y7Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.14";
        hash = "sha512-AmLrJ5tBEwPK1VMPdk4Vy3Z6++yGkaL5bpKwGpY9SUL8x6nwQjWfY87snOK99X8NEXltxJNovP0FkRLCi+Zr2g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.14";
        hash = "sha512-jHaj6hgSuJ8d4jPFSWyrbyQROhTgMqCFKb+RcNpRf1EJ/0kHbu1vn73qxURYjiol+9jaEjKanJDqZwh76x/tFw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.14";
        hash = "sha512-jYd+5KNUzdo36ytc1Lz4TlAeHhRNMXQr3cdBzYAqCx9wfsOUnqPM24nx7XNvNryawyjPicbdP2wiNBgdQlts7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.14";
        hash = "sha512-++Z4DoiGwsqVoGM3YvXsWoEzLVXSXQvTnIKUfCV/GIa7crEgG34Tb/yYzyJvdFScqrHbgf1gYyYeE67iBhlgDw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.14";
        hash = "sha512-f7N/o6P9rxLrfKJyyy7pp/7ytpe+CNa9LdyWPjYBSTiVi9bIPq1yXK6MM4PewCkLsoS0jOOEWmfYHrYb5Fw7VA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.14";
        hash = "sha512-14RbsWvcKBwytrmEpdFvKhFLif6UDfEjlFsZJ7BGREPDNGXg197CkcJHCvn8nVY5jnEju3zCmlSSgPufgd3U0Q==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.14";
        hash = "sha512-RD/mlV6K5OupTnGDEP5KIFCsqsPaPJnxZh3SEowf/ShRL3djfZqz/a3WJVrpyjt7jpiOlRf+3HPl3pGmqZoOqw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.14";
        hash = "sha512-SNuZTEbjDCUasMXqoRCOPR6zkIeaORIj2FZkvUY72M8D9U+hxOjDhf3DltesRmtOFuhDkgB5KNCL6zriAvbung==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.14";
        hash = "sha512-7tlCJe1E7aFUXY53OFjLD+LAsblMfMDBDhLXLx3QdYA9IRKopXQrCtAvFQ+i+i56mKs9RVUmg2v+RjxXwP/MUg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.14";
        hash = "sha512-/UEQYhm/+Zo2ulnZiEzP18vqcPWgqnFmlobEvZc9TCVGx205H8XoDsZ5+MU156Vbu2G6K8El2UCJeE8X9qXRbA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.14";
        hash = "sha512-YWI8RNne2riYIn7tn8+5ewJFIzeskhJ3MfiZEHh17lmixvwPczfW+uqRdHAZ0ERYWpYFO+rO3/4/66WuU4H96Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.14";
        hash = "sha512-Ft8hxap4jV64vvOdcomyEJ2b1HFmXE2D1d8Ib0iNcbf/0qyYxosNQQa+Ttzq0AoODWmq6cHdWjPAfYgMQPOM8g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.14";
        hash = "sha512-oF4pLSWyrR96tyVignbQ12gR+6JcozCv1BO9mBy4j70EDsV7vpm3x3PGoA+SaXaDDm+SGddFElx+MOUzB8jEsg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.14";
        hash = "sha512-ReEgJh8mRp1wRzHjkbIZVcLZyBj7K9KZzYjHhzOCS6gFEF/V/4fesp8MVlzLdXSBV+ZunSUwL5hWWvUlx+nQ9w==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.14";
        hash = "sha512-jSo6p8k62QbPGfCFxRJEnjTJz2HKEV3YP9SXYyTRXnUrXypLzHqU0GUQmgzMGZBM+MTHUEsH6Bhy+r7j1QpICA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.14";
        hash = "sha512-H3zVn1SRcQ/anQpfg44zFVsAtkdj8YAdrNVU+dxe/2fB/ZBjVDZaMoTT/d0fd7wyzDxufPE2IVXK7JyeExsrfw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.14";
        hash = "sha512-nk3joXKiqVG0ryUg8FqCAlfl1hSqCL5gbTFaIe+vC1eVheitArOaxY4TU+tCsG/XNoskLaAG7ptU1eXMpesung==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.14";
        hash = "sha512-UIwm0mfT7u9HLdfVi6uPBt9gplnCCbncc6XNOhYJfEB441j2kDRkKDSVhfXerA2lCut0U4fQQm+i9qGd6dFlKg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.14";
        hash = "sha512-Nxre0GsAxbGLmlfymqMYsWps0rexVTEyKyCtv4SZs+OnRd16xd3YFoxuqwaqKOSGuDPRIX9yJF/POjWnanA0HQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.14";
        hash = "sha512-S1jr/9rRWM2bUoz7AHALT5frHBnAiHWEb5WhrKuRzJogN1bCDOpGXnkZ0zEHbNIbhTeZbkmMLTkch/ZDBvm8qQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.14";
        hash = "sha512-1j/Sem8h5XELOfV/8mnVdXuYcltI0JXAyvzNeC7uBJlH/ic1HZ00TQlWsv0/WIgnHgSTAgNaa1HxnAYL35NITQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.14";
        hash = "sha512-8mOcQRKCm9QisJOZ8GJTV+Z0pStXlnvCAQnmfYFF408Vo9c08bnla0sHRHobFVRxtWqMojvHGHwnUlnp9XrPLw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.14";
        hash = "sha512-DPYynWbPeB1oLDtUxOQLu5SzJQlqQzG01mxGoD1qTjDK1V1a1eVWfKMRZ56tKkIS40zywn8ku7Rpmrf4F4v1CA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.14";
        hash = "sha512-3hDLHUaEXPG1j03/fk1vpJZMRQn1TFh3X5yGdFLM2d30R2jcKf0IQruN1x4r9QtOOA2d3WpQJ01pYCd/GK65OA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.14";
        hash = "sha512-2mjykmXgsvwZb6qItFVw5uTNlGE30SdjSbTaDzwElYIo0ZFJHKYMuQsBxJD1GUzets0n+g0Z/dZ+MjddeYI5Vg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.14";
        hash = "sha512-fyAsLUnRPvTSnzOax4IQHoSdsrBbAYZ5OtMdulCA1prKJ82ZG80stokdB3vkvLyGqGCg6h7R4VhsZrZRuFKP7A==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.14";
        hash = "sha512-fXXqGF24E+d6zQ4JoiTfnlb84ER/G2RsHJRiv5DbljthIGAv5qxnwT4B5C2EdpOvipovF6i8D2z9oDwNwThR4Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.14";
        hash = "sha512-wXiDzelOZOfYgAgHaYNyXq9yFEH9H9JtMIBMAt1XLe7aB9t8ikOi6ki8vW1/xCVyTChQD+gRvFyZ5ndCl3h7Dw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.14";
        hash = "sha512-X8m5Y7a4RUtBzFkijWHGkKf9RI8ryfPaVKG7U8L6EJQhhlcaPkrR40tsA3kLWu0BrrsSLwYA+QamwZjrubAB9w==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.14";
        hash = "sha512-HQXY+yGY+9+Rkmj3g2DwVKQDzhMWANYVsxUD1btokmnQPmznWt8NWwF6pFkCcgFocbzUYTTlmxfKb+LVI928Uw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.14";
        hash = "sha512-ACy6Ms3VSZ8yGl8sPOheIzmJf/T4HtkW1ZhYMiYgbA3dAIonrDPvk0SACANEwmLAHUoPSRkZ4xEqDrg0EptzMw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.14";
        hash = "sha512-YLy95lsjZts5RPMNk+ahD5LKmKpKMNvtXOqHNdz9DfjG3YEBwzIffGVVs51NkWf93ivLPGcBcn/VAzuW47I3UA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.14";
        hash = "sha512-xuo9nZxqdcbn+Q4laeN3a3RXr6fPE49EzLU8uNj506udjEKL58J9IpbKMX3DU9zE7Wp1p7/AY68UkHqOlVtKOg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.14";
        hash = "sha512-LmujYamAcv6GHlRs4xhnRWUKMfW4n9gI1t3w9mVapHfWZ9ErbgvjEJyXNTp4qmB6xIR00ggXLSQGfRuiZV/KqA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.14";
        hash = "sha512-cH6M0YAJOZOl/Nb1lllWqewvsgBZQ8x+ix7QImG5WFvx4nSuUDINRigq8zZeUL1Q05GTsC6U5CVWhY1HrhFdOw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.14";
        hash = "sha512-ZYOr/UXKLXLdhsVAvRKZu9mVGdFw7282EBgwvBIUZR8zzVxd4qseapdw9Fhoop1stOtVcgs1RGqnHJdRx5O1UQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.14";
        hash = "sha512-7Wdn3dL26+J/Gbl4hM4uHARyTcLCv8ugk/gQ18hP6JvUXHkqZZzsOr0bVqTXU8+2/Py+shyIkJM7nqANTCaI1Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.14";
        hash = "sha512-w4B7gwQCiSW+m8ioNz6oYEv8ZD65PuZfPN5nJPegjQeJQJcpPjl8LS5qS4zIIF99tDzL9HdbTd2/ctUwRrVJyg==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.14";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.14";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.14/aspnetcore-runtime-9.0.14-linux-arm.tar.gz";
        hash = "sha512-TBC0tyYmkKui6pajHM8MzIRUxlR/BmNwqm7pJjPADoUFw8DOjdh8HFepegYDJ/NMf0QlqFZ+4gEjqbrESbFQYw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.14/aspnetcore-runtime-9.0.14-linux-arm64.tar.gz";
        hash = "sha512-xc0FlxycugwhHOtV4ibL+2LxctuDRfpdTkdqTMs6T2HW5R3CstF461XzZzrS1hz3KuZJ+4TM8sPbu9Ss27eBMg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.14/aspnetcore-runtime-9.0.14-linux-x64.tar.gz";
        hash = "sha512-bQlHOQ+ewxYpfyGp7AIlKKJyBaRDKPlBf7hnV4PtxWAi5eFeplZQxec8tzkXwJxSMF0+heTBKs1eEQdIcbsGeQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.14/aspnetcore-runtime-9.0.14-linux-musl-arm.tar.gz";
        hash = "sha512-zrzx18hUhb1dNIbwRjCB9BN1llCaDnhh4xp7XsNqkMex3nLPKJXojRdIZkC7dZPbK3EQhYo3cbbSM5hlyHwSjQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.14/aspnetcore-runtime-9.0.14-linux-musl-arm64.tar.gz";
        hash = "sha512-2tBpSpdV081M9ea/4wjqqLkEYTkYTIVzhyKwNuiPF4+NY/mv7RLiZPLEHRPmsYoXr90d77l62IdaIrtILcFhMw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.14/aspnetcore-runtime-9.0.14-linux-musl-x64.tar.gz";
        hash = "sha512-gfkhRH1kcJoln+AIOLN7vUoor9ZZOMqgcYvr/GDrwKohsDHwSQ9KFqrI/6T9rvaBAbK/DX17mSKT1g+3NXqHfQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.14/aspnetcore-runtime-9.0.14-osx-arm64.tar.gz";
        hash = "sha512-VhV7qrlOtSivrPkhaX1mPrID4RS+mOCKAxUwPQm4+F9y8dGT7tpx5Mg/Tl38hRffUoq4ZJ0XVIt7YTaruvfr/w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.14/aspnetcore-runtime-9.0.14-osx-x64.tar.gz";
        hash = "sha512-Ts72neYQT0t8dKvHeXCeSAVRF/3KZORdCUYaoRmCpEmOoXW+z6g/fSrZrbiWyYUXAhSOdAPr7ifrAfFTWcqv5A==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.14";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.14/dotnet-runtime-9.0.14-linux-arm.tar.gz";
        hash = "sha512-K3U+B6gtlvZGzWhpuejfpdmCEElRqEBTcu2RpBo1lqts7bHmnDUjhApXN+qRtuMVzTQSSF+B9wjdtLgul43aTw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.14/dotnet-runtime-9.0.14-linux-arm64.tar.gz";
        hash = "sha512-D+DekyKzozyyMlbOZJ/lqUlNtUdsUO8lM4bXTp43Ipk87jh9aFAGETGti3fxRUj6E/dyyUhsMq6jzQjjE/dvcg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.14/dotnet-runtime-9.0.14-linux-x64.tar.gz";
        hash = "sha512-2w2wuecJ/+Rj3q2U+053ubDHCGu6p4p4qmtTZr73e6PDOJmoHDwa7zwRAnoebN6/SnrTBTK9wZPw3sxxly5d2g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.14/dotnet-runtime-9.0.14-linux-musl-arm.tar.gz";
        hash = "sha512-5l8d7bW/Se74Ky0rCE5BPPrNL6VK2QJdGVRo6TNpiDRfjJROxQ2oVTp3vG+fK4S4yPMEGy9pshpAVC9LOn8BsA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.14/dotnet-runtime-9.0.14-linux-musl-arm64.tar.gz";
        hash = "sha512-bm7BOWvjDk04/CYgOk7fWotjEHYm6/C+CkFK3hmwuKbJQm7QHPMZiXlogcr4ETjnmtLzR4+Hd1tomVpN120Whg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.14/dotnet-runtime-9.0.14-linux-musl-x64.tar.gz";
        hash = "sha512-1tW85BslqLqSgjEI0/k8UajaJffCL+ZcEh4Z7wky2Jc/iMhjvfItHs8ExJjcanI8ZT3jAHeZP2SGWbw5HzkA4g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.14/dotnet-runtime-9.0.14-osx-arm64.tar.gz";
        hash = "sha512-I+bbmZG+jlrTsGD0/oKGAXa/Qx+zSR2f1lZyWTvQBLqshg1JuoOozYRHZqcUGwcMj6jQyKXQ+mi5uNFTsKk72g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.14/dotnet-runtime-9.0.14-osx-x64.tar.gz";
        hash = "sha512-fvOeVkit9BLU5WTwgIFh2X7nBzG7GSGyZiltM+1BgjGjGP87CRM/PaCloYkn+VE8g/dN5e2cMMfGb1jXfuh0jw==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.312";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.312/dotnet-sdk-9.0.312-linux-arm.tar.gz";
        hash = "sha512-x2vcsLSJRGaFtwhZd1b6Rh3VzLWsSte/rg9Vq9CJcRavPnqLqveKM9l/EQnECDlFsMGfeJ4lzYOSUB0MUrDH3g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.312/dotnet-sdk-9.0.312-linux-arm64.tar.gz";
        hash = "sha512-5SqZNI1Ql64mMEnBTHTJPZr/vgw4YgyO3i0RIPqg7eLxNHUl70Ce7clUhdoHcE3arVhX6pVOFFGSDwNz94eoFw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.312/dotnet-sdk-9.0.312-linux-x64.tar.gz";
        hash = "sha512-QwqsYdUJsCCtwX8K236Btb6FBG1JeEqy/5J8qRCGJcXN9koOGFoJ3yNMKsHs/q21sQcU8Nm14MH3K1sg++10QA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.312/dotnet-sdk-9.0.312-linux-musl-arm.tar.gz";
        hash = "sha512-uI94ky7oAojBqc9dgoTT4Kor4YUldbEJKD7IAKjIauwXeD3G5EfBR5otscPvg9lcI+qy8CwzW5LLofkMB4aO9Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.312/dotnet-sdk-9.0.312-linux-musl-arm64.tar.gz";
        hash = "sha512-7OytJ4U9M7R1EMn1gPySEu6NNGL6ny05MHnreRKke2NB3TIoF45Z8SPGyrThaTPyufcENIvEeNEyph9WrQ4N+Q==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.312/dotnet-sdk-9.0.312-linux-musl-x64.tar.gz";
        hash = "sha512-2i7gKeAxUtyJc2L4U1MVyaJmmBgWVpgbAfY4D4zZRKSJFUHL32pou6MUVZk0lPK5OuuQ5K9qPixn7HG9pGfJ9A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.312/dotnet-sdk-9.0.312-osx-arm64.tar.gz";
        hash = "sha512-Rytw90lvkBpuHOf30QBYHorOrV+ctGwQJlnJL0E05KaT6c1UFsmRtVs+g+hTYoC+h/hqgldVLLv63AHhDRPS2w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.312/dotnet-sdk-9.0.312-osx-x64.tar.gz";
        hash = "sha512-+TgT3q8QKqWHQCNVmaYYOfylxoZoAykmv3bNL+76JgA5jy5xoUKGQ32OhNmYJe78CFHnW71f03axs6OoiPnS2g==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.115";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.115/dotnet-sdk-9.0.115-linux-arm.tar.gz";
        hash = "sha512-cAanOGAWneLKPb7IlfGYYlxHLDxKEueHqUyGVFei4vLIWh3Mog7nwl/j1xa/tIdri7E7LN0nv/g8QH4dDsOZOA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.115/dotnet-sdk-9.0.115-linux-arm64.tar.gz";
        hash = "sha512-zJhNLUXOnu0k3Xih2SG0GbgRMZJ66RC6UL0oCfZMxADGUlJAJwUyopA6VPWQjEWAmGTMNUZVqLpEUBcmN9z+cg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.115/dotnet-sdk-9.0.115-linux-x64.tar.gz";
        hash = "sha512-g38je4D8WM3Jf4AVTHz+UFpzKNyTxUFAZwdhBVq1bUHaEfhiDlAKpAVXhqfuCxOLW3Nga0vOThLIYBukJtOtgw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.115/dotnet-sdk-9.0.115-linux-musl-arm.tar.gz";
        hash = "sha512-OwDO/OCWK744lXcdNyem2R8gjm+IGfBeZxqkB9e0zslYUGSwHy3ujWJn2IaAhMZ5uIT5Jt19SqDBXwXX+bQt4w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.115/dotnet-sdk-9.0.115-linux-musl-arm64.tar.gz";
        hash = "sha512-A+DrkfpbPaqlCVp9RBbFGNwyPM5cQs8xaxsJT9s7gZfhjhr3XUzNUR3k66gEqjs5nUEEaAb8sep5BSPCj8BrGQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.115/dotnet-sdk-9.0.115-linux-musl-x64.tar.gz";
        hash = "sha512-DtLBHH7hyOmtRPXSgF50jwCU2jGHNi0KDKNCqnWvz9W8Gf5yOSPtvdC09nKtxFXBj8jwgaVBWZ3xbbiFXj45Jg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.115/dotnet-sdk-9.0.115-osx-arm64.tar.gz";
        hash = "sha512-eU+QDeVY8w8uI3WWXAjADdSZCq0p4xv9CTsIsdmlv1fHjMbz22jNhTB2+BaJKJjEPVCOeES0BguKkR3Om8x3Xg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.115/dotnet-sdk-9.0.115-osx-x64.tar.gz";
        hash = "sha512-J9XlO62e6j2yJSK/w89mE8GPuPHdW4INzZe5fb+NZfLz6sc8Bh3OkTB5mhWU0fKZW2+Jf8hS+3F/52s4ea9QFw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
