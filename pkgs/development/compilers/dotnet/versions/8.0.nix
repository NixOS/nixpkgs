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
      version = "8.0.24";
      hash = "sha512-CwKngB6eZePFl7i1Dozq8oHXu95KD8trxC4NIyqK30p4olvY7+aYi5ity62OT37jX8VasUg9YBjnqoZp9jUTzQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.24";
      hash = "sha512-0aXrhMBnfIXi24dVcWzHVwDX7y9Sq9ieNma4O6aKDCIhQiR0exH1+i+WM0JEQAKRzu6ynlRVSlJwV5NJVIO5HQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.24";
      hash = "sha512-86HxOC1XFawpT8+6SohqAvOJpykMJJm+d5gkw6XjjQPQTfnuQ8B3jKzmeWEieFHcQnZGEkgZu5Bx3mizoNnBaA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.24";
      hash = "sha512-2zriYeNKwwOFNoZYXptk32S4sNMJuPP4L4Fc+/VTOTHShfbIdbrTDOxZ+JgLkWERt++oo2MFkjqraSv9jT+bog==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.24";
      hash = "sha512-/F9X8+pBfz5Q2zURiMNDn1FWGhQPQO468en9tDoJd++xwhSTPEzbau1tG1hGTlYPnOnYULT6DzW5W1Bsey/PSQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.24";
      hash = "sha512-w8fkFcG3UlV/tpdurbI8LNF6cKo7/znP//EsZ2uhqycOqY9LmnL4evdrmLV+Esi8kfk62U31pZ59Vs9qB53hbQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.24";
      hash = "sha512-GcTT/Uht869SA2pG4Kdi7p/PolLsosERxJbdq7pEf7B/dFYPj1Jr8uYWvkkLIx49P2r7UNUr8Jnz6KFFqCl+tw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.24";
      hash = "sha512-5dghNlahtTuvxsK+0ZEHuufjE4p/OrVEHbGkaNLZ7MW8G7AngMPWZGWXGsC3Bg3s2zsGdhj6VkzQHZ8uS4S6yA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.24";
        hash = "sha512-REd9Qvyp1aS17p+MyZST5WQODezf3TW3nmFhxj2MtpbdCK6PwzA2kQoXz43lMCfnlLq6YgQtROZslfd9Oc4A1A==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.24";
        hash = "sha512-RegTSfrn46goqO44gYdk//I351Z0QMWzsT5/k2Io/jXZunRj311i3Bm+KmrXixmHnrDnCD4oXBcyRuTAg0USXQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.24";
        hash = "sha512-ajOV5ct3qzwuP1G5ioR8HJDNDyD3p1giXpHvuwaE1Nmw5YE1Th8/VwXE16bYJjF8h2xeStTen/4S+tpyphq9+w==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.24";
        hash = "sha512-A8rf4X7A95f2rBMiERRSaHhuCB8J52LJih4K4m9qbgzuMN2GCbuft1nmKZFfpqp82cCrsufdt+L5yhLPHALBCQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.24";
        hash = "sha512-yGT60Ws8Xt4EZDV54AFaOvaDwxH0gr0wm81P1tK42gGNwiu6t0v/iqFSJ8QrN/j8ASZUD3BB09b6xP5gAF4jug==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.24";
        hash = "sha512-ZLlw/HEhuPr4zTAHtsUtDdIZ5Mad2I5jbHkmcmmdYpJPxNpa6khdEaaTzMYbH+XcQD+gGAf2M22OE5r2lZ6wag==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.24";
        hash = "sha512-v9FjnZ9HWASvLFurbzn/VvkZx6pOOKwXNH9o75FCym6lT0TldLJQcAoWBMVWT5npLtYaWBkaB/7ChNx2LgQ49Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.24";
        hash = "sha512-wA3wzKyE4DlFbGgt60KObiE8ZWhLzHT79RDz+Je5ckgGKzqAAlSjuofE2ane2wxqs732TgVe2fgSIO33Iwb2rQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.24";
        hash = "sha512-bxNsOR3qaFXC3kYUQZuyeA0Sz9N2eGs7oH80aY8gMWQfl6cTi+efD4cVO8vzABsEg2r/1aALa3Ry7kBszKfU9g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.24";
        hash = "sha512-+6+pT9LdORbFfL07e5r/qKGnXE2ZuleNaQy/2pL2kteyK+d4+4Su6YRodUNPyiSw9A5gHS/WCv0kiqSyQtpOYA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.24";
        hash = "sha512-kWz61Ly7ApV5gx6yTxmFEaAImucwB7dwS3ThQVXaf6KuB/pXFIH4WWCfAYyIdtKhV7XOmPBuiKRCcskGF5aV6A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.24";
        hash = "sha512-KHwGOGhpdtjachgKa0KNk6Q9AdRZIwiV5gqH3tfz1SR3cYqtHGZ6Ae2Hz1q+4/2PCSDCuO81hN170fecDwYatg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.24";
        hash = "sha512-q4afpCvipG01/hbd/z4gR3ccPI5yK4tH7tJUfQdQGoWG16aA9c8dQIGwJ+c2BQ1h6BiJEMXUIglR6g8D7zz71w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.24";
        hash = "sha512-vowAE0Wvho8IO8XQi2blfVqAQ8+WSRgDA5oUj2q1YPh+IIJZeBra/W/BEWrtxH/bhgKa4pR7+jHqbQYrwRKRKw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.24";
        hash = "sha512-veZS8IvjGHjMDW2PcXf8P5x77F5Jft1qGBSgHOJm9p2zUju28n9VtVHKE2l7/V2NMTxGeVf+9YMzzrKx+cgq0g==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.24";
        hash = "sha512-qGimcbj3kV2S7+oDPgnHFBoVf9A3w02pYV9vSYuEBMjC1pAhcJ0cCn5OxbkWpHXe3sqtERowLfECbkqgjfrsqg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.24";
        hash = "sha512-bN4iPw12lcddcc5z+Cbrj+hyw3Vxe0iygR9TqmidEhc3jO4RXJnAMm9mMErm77xajaIoaAZTS/iwscOqvzQA6A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.24";
        hash = "sha512-GgOqoYYR5pVPGIwjhhwLcsmlg5BzBT4FIn5VZHa+ww1CHFfaJ+rSmsXrgJUiZIk+tlkOIuFk0Qs1elgFwJ9eKQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.24";
        hash = "sha512-JDL2Mv+XIEmWJn/IA31f/+SV+a6X00lEMDnjLL3zDlvuxamfUaDxlGj9OEzrvFJ8C+fIPfc8njYaJ/fhLh7lQA==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.24";
        hash = "sha512-VuU3R/9Cfy16eUkEfs0brBuYYo1gaIc38UdRhRNYhFLrpD2htfBlyGnB9hBXaE3vx8gp7V9WnZklVCGoFAbRPA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.24";
        hash = "sha512-jnVICmS1y4fmBr+WORN9MiLVcnMJ0Oaon75IGXrk3ovQuP4kI1ivjGK5OrcQchee5j/LRcT0KqdCnHlmW1qTbw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.24";
        hash = "sha512-KsXgoVIZpm1RIu+Vsfxu0YLo7qgNjcKU0zUrLhkc+XpOEgXqJ1ta1imY0sVPghPAu0JPXJ/BtWJCIAf9Nt0kEg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.24";
        hash = "sha512-BqxvcfEwr9ml/KmvhU9ofbmlosuNIR8/3+LcHYcA1BBzQquVZi2qw9qs+h1hagpRDGFNsVzz9v0Js9xVaM4n1g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.24";
        hash = "sha512-JkXcWO/k+56v4IZlyeUM2vq1TB/qNfY+Y6QbltqKrFqzBEuWuSk5qlZK9rrw8BIVKw0oXqqH5hgazV9qsf3gaA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.24";
        hash = "sha512-uTs8LHjuZZWIwudKCbLmxLvNwfwh8iRXZyNdtlue/2hfoACcTdt2DY/tbPCgjQ+NQMkpgn7lei/Nsl3y78ar4Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.24";
        hash = "sha512-Xoq92IPqDvHnT7Ry3NmS4iUaEok9oMnOYrZ0742BSvqkAr1SWYtswVrZ9h20I2nJXebyCksU5HJXBLN7578gfA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.24";
        hash = "sha512-e6g3ZCZt2hNcE+hf6TTO8c1qGKrB5qijSwu/aLMfAXUAoOGfsB9qvjwuHMfDrTkcM5kAe85+UBa2KNucPgTfvA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.24";
        hash = "sha512-faujWPHNz295c7uWORK0vXTH1SQNS2PFtwyHQx0dFOrytmYjXBfKwfeVHsW7SoqVybZCfpdqIYVdeQU0lNRALQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.24";
        hash = "sha512-sTwO8533Cvx7W8X1Bf3JSCBDnlKOT0fr8ueGwJjnF29w6+4k5wJvwkRsQ7Xuv/X1oNClLCjlIqQeJW3J4njZRA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.24";
        hash = "sha512-D9rPfy7nJ5cYNSTfuajuwbRWUsyjJOs3n3yvolWmWaQWes+Jlj7zIeYN47NZryfOjwmPGu24HXnJGTE4UOiZXQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.24";
        hash = "sha512-MvQyKvoOC7cpWaT5hmq3X1kIpTPptogTvhCn5GjuI2zSOIxg+U90Di8pUKrKqS/3Y4fuByNwfgMPbsWV6F1ylg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.24";
        hash = "sha512-Q3g1IhvU8NpMeByEEB4O3nSct73KLaRgROwufrmBuf0fjyBFQR6SvUxRVl0Nrs9ySTbxQA0SaGAPw9xYlB/G4w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.24";
        hash = "sha512-TLClSCztrAITpJenQyr4KVTPwPJCcGo8m6pNCbOqr9rIDg+ZN2VGVExwLgUmE2ZWisYL+c3giFIILE3BoN3oAw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.24";
        hash = "sha512-0GQ2ZmFp54ZNt9bvCP7eDpcNM8afBD5oqXVhhvOFLaACI5fp+iSWePxxhlqHOuiLrxdtCGAD43LVXd8U/EZk0A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.24";
        hash = "sha512-NNllrZsnasw6vkLWZhQ5L7QYfV60KXCYSWySqV2agcC93/1X2XKPCmdr1/4hTH/ejD608HAYxMRMdmznBZbkWg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.24";
        hash = "sha512-94Bb2nj0OswRS3BdGY95laNbgGs3rnRrUJIYxrafmQFWUzgrQTm9WBLtwaHbgyyXzLdq0J5H/cdfAGbAUgyQrw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.24";
        hash = "sha512-JzRx8Ro7wIsaq9iyhROxwL6ZBBE3tXIXbJcuzRC+ASzyK/zRoDSalToxw8oVIAWefO+9c18CmeY9908VumbXBQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.24";
        hash = "sha512-SSzr2v3+zHbO/ou93p7T0zaaWGgWDU/kwA+obMYrardz0MdUIsvKumU9/nMrp8lQIIppuw/Hu/BKnpSjgUAX2w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.24";
        hash = "sha512-t31VLpcTzKkeEzcwhFXHnPWN+NTv8tOiZwu+MxJ8PnHanXMZOP4ta8yn3RMWmDlMCh9gPeKjXDwTSrGZ8KA3fw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.24";
        hash = "sha512-ZlDsofIKO5zUuV0qYmTwo89rQfWeoT4x9BQ6Na2Z57/TN3s3rX9VqOKQ9KFWpu7bR46Bj2fciMnHyDe8djitLw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.24";
        hash = "sha512-PcQz2kp68JdRj+2Gajbz8rcv7leJ+owCPKGZDaE8B39TvVJrt3OsqLnVF8PCnV/LR0vDnwpg5gwCPCch+7t8jw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.24";
        hash = "sha512-OEd/nGdsvvsFIUUb5jbgX4x7xlO0gQAuQfwmmONnJ//PTpOh553e+WVjKl7nT8oswioxGVMHr3Kt2N/0P5coyA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.24";
        hash = "sha512-CyCjBOeEcokqHhPNhImZsbUT7je67FI4puxkBpQUTbI3j2iZDjTNBkuOQ5K1AgYfn9G22Zk/bmMziDPJGAYzVQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.24";
        hash = "sha512-jO+9+5Ayqa0nVHE8zhyFAcqO8vBiHzJRNYGvMUOghQamsz0qy6+CrmckvNmBqELGOD6LtBwS8PA/gDmi7MAo7Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.24";
        hash = "sha512-ONx4Hy5bTnkM36ty37+yMQMgUYOl7p6LJp6mmazYGtzox2/8/5ZjOVZeS50fMKmEGeTTIHlwTHSfp1xbwlpzaw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.24";
        hash = "sha512-/PhFniaAD+fgSkP38cATe+3PQCWunNz7uueUCk6tJqvKEAFTge5AAJ/rw3ONzzzvjs/6tBsS5E8IgCs3NZ8Dow==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.24";
        hash = "sha512-+39V+6drVud/ioeIPb0XIUr7jKUPQP7B1XMU958iCVicdqNrXZRV/BjLmolr5QzO5Bdwn8N7fcasedCIeKjktw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.24";
        hash = "sha512-CxPgl4Z3Vlk9wnEkn+Hx6NLcCtDobRsai3JC19/ySOB4V36fCVQcH1UQ3VjG/1knWNMTG5ZslfCTYM5E2pvnWw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.24";
        hash = "sha512-1FC5WkBE6V+qRcdjzSXf304/PZ1uIzp3G7gJ6VaoG2wK1/bnzPefAib2Giv9SZNFYFauIrxbwyosUf8A3MV0oQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.24";
        hash = "sha512-jXl7yR/GbAkmanR4vCIeB3SS7NNSaQcNOPT8TavVhsItywV4som+WYykkItQ8Sm0HG5OKvrcn1+5KJsvy8WpuQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.24";
        hash = "sha512-CJOTVVULYuhWFMzZSsVMOz9mJSWZ+ZmcXpWR4eI9dREoleVH26O8dsJADsyjLK//qksp+r9qqLJZ4stmSWdcGw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.24";
        hash = "sha512-pVy8P58lQjVSrGYi9RQHFfsNlmU3L4DE24wznt7RufF9gq1It0yaX+Vztq9Q+QMoBhOO6Qvqdq8z921YOgkX/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.24";
        hash = "sha512-uF3LxNM8HMRv/eWumfwWqp3/w6XziqGDgUI/7oYM/JUXUPUjOquy+A7YGY+VndSQ7NdoFS/3BVDgDB36wAvmiQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.24";
        hash = "sha512-xn/0fTh9djlk6hTnxLmUupkTLL72bdUUtBfz5o3UaJAN40wK1EujsHj7Y5N7bHg3MMA3NBaLs3Jm+rF+2lh3Mw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.24";
        hash = "sha512-RVG0rxVkfYmwE98s0hDywyhQMRosFm43j+qEH8/vaLJ5yRP0r1FA2P80nux5CTv+THKW3Vgb6xbfrV/te0wwWg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.24";
        hash = "sha512-oHMW8bygUX6yHLfmZZq5jVoTjhk31VzX4QDuP3ZirbDZTalLBVSn4VK32CBZ8aoYD/FlS2eJrDyeAkKX3rpjww==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.24";
        hash = "sha512-FaZMI4hlZH95LUdtNT20Ddh3t1bSYDgCGi2ZlaFCvXb2e7VYRLmIN0BKFXertGB8e+cQ2g/9kqrkBntA1siaFw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.24";
        hash = "sha512-gbKjR/S4xlFao8+UZAWlK8COu1bGbIHPIs/KiV6PrfGCGJ48yqnuWNfmF/hN/6mPn7N6JlK0tdwkSN664UHSgw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.24";
        hash = "sha512-4zoeK5KabRzlYf4i7lGjPaXYuZGv1X1mOVfR0wdI6I5EnIxBB1wbaHFqBD8fvkja518xc4FDaUpbS3VoMx9pNQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.24";
        hash = "sha512-BwWtsbkMYwT7B/sYCFN43ngUu2llOE3OqtJmq12m33q2JECEyyummf0R83rF10b2T1n10nRq1qvShSOuldzVyw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.24";
        hash = "sha512-D2v/LdM2CpvbNi6w1ZhukiccfR4DWrNjbbP1tsLERCpPEamM3tYLgBv4zw8i28P5DEXVO3Abc1LZjHPYAwR5lA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.24";
        hash = "sha512-GthM7QNSZFaeu/luYQ6Jd1uqz/leCcrdQeBIUVrBWNcJ+aV4YRQhen/AftdiUpSfMl9K0LCQ7QK8iUBjdBPLBQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.24";
        hash = "sha512-KJT/GX0azpINH7UcTSxBAuU4CBRQEngc0SWZUma38DLwhRya7B3EVyIAJx5DK3fxGxewmKiWx2c0p6vvhJPRuw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.24";
        hash = "sha512-CScn42is71zMUjP1T8e4Sidkcg+TRwoytjfE7qx0oo+1CbRCMFSEOZ5fRDTGLcovrLzuTlq6Ddqu3lBgRbRlpA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.24";
        hash = "sha512-VP5+ywReddZ64OvS1CFujvvYVEeF0+I57kFUT+g9lY4SNtKHI1p2QfMrzL7Q1vJ8TXbE9rgdfHHJHfMuke+qDQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.24";
        hash = "sha512-uR6R720cWKeNPrmNpl8IyBMpTn1Kxtfm8BUtEReMwZyKAjt0AqazyKZOA4yo+pcDscN6qGZ7XsatPWP+gkm0wQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.24";
        hash = "sha512-gsez8MX1W9ynrWNI+xEq04o25Mqc8gUw7OyoR5ljvLcnIt0zTlSvt7BcVPUemKRv2Z6pnCodXKZHR5f05ypHsg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.24";
        hash = "sha512-UevsJDxErF3YGZxJDVnGqj0+nFAME8LJohYx+k7yyJPI78ksOceBDNHFYpaGeaTII4iXq0yWZxmKpKA3W3a9VQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.24";
        hash = "sha512-K3wtuV3gU3cY6o4cNSbDInYfdXyI7LnZzTlcENCNu5kx98qH+bFQJvPe9CW/Tq2P0vqIZ8CVKzm9OQtAZEkZlQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.24";
        hash = "sha512-ACG7yv6QTZ/zNfXols3LQYTbfyD2z52AFo9kjtXMVNV9hf9zsAELu0k2/8KyZYXX4VOooySpIKSWC/BnjW/Bkw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.24";
        hash = "sha512-DjASBeiB0zQKFmmFx2o7WizK+GywOFxfNEoAiz/AN4ry7XP5nKag24dKYc2Szhv7nGnHihEEMkTShBwXJRPDeQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.24";
        hash = "sha512-E7eblRX3ZHtNKjYfJwJEoZfZdkYUuQQutFlkLjuRZEncYh0SblOtoB/FIYPrndQQIh4bSkY271gt0yzz7QlRnw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.24";
        hash = "sha512-2mRljuQDooQY41+wdMRnnbvcsh/ZOAyPO8Ifhv5ImAijoG0pxq1j6d1Y9/NmjDuQqxmmRk+Vw5T9nCuhr3awTA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.24";
        hash = "sha512-n881oBnZQ6xsELkrgduN8JH6yZU/We+9ACOF4dUsfyLx9RTh0EQMsUz5tTAzXoenBDZ4p6RsdnjFgDqg+1f5+A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.24";
        hash = "sha512-qGbPxfG/9edXf0HK1a+Dl9zE16alQfdsQJ0JvNDe/t2RIIJv2co8iddscodLEY+HrefGy/Kh5MzEjgf+nVq3YQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.24";
        hash = "sha512-gwk42rB9OCdcw5ncNr04zr/wi6IRmeAd3x3z36mMtdRcYoR4oq01cQl5VecG6YjqiEqlUxFAYnygaSck+X2b/A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.24";
        hash = "sha512-fP9TRao5w7mReiVMz2in2wBWMXcaSE22Jheuzgij0iMKeadAk3ARPQgQhrHSiRd0Yzu5VeM3igQV+TXq/SG+2Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.24";
        hash = "sha512-sPDRuNi5Ipjgss1S9ltoVE71cArqjz8GSkmB1SRlWu46pAqN4dUVWYYl9aFIHhWwWkXnMBpaOeyfsDi8nChyVQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.24";
        hash = "sha512-5tsQkN6BzdBhwizHQLXuTk14J6POyVjrtllxxWxRbfp7JzhdxNhkTauhpP1Q5oh+jpJNF0Z3C/rmvTd3lfhZZg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.24";
        hash = "sha512-UC0P9/SHSjaDx+YxebFcBCluuZI1t7dnC0e0kgiCrYKZ4ty/2Cpk8gSACZObHb/rJY8PUK8bZDdvWXQhUH99JA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.24";
        hash = "sha512-3UH//cSkT3UEuNWm3HwHKPty6YVW3aDC7a9PbWskfDb0UOvb+3XTGStlia1kIGwA/RCwxR8KnCgClwAIN1gHxw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.24";
        hash = "sha512-DWomDaA0F2Mi+h3oqH5si2T67JnH0wQWfoSlh8JzEZCBPdfJConFsnCi2bm+wI8NhAxEUbpt6l3lJfH71O9ubg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.24";
        hash = "sha512-8GgsrIdgCMLXCQjUV2LGGX++yUwZ1C+EpB+KO45pbalxgHHJdnY3BcYawzgAnn4ZcG/cnaDNUJF8w8A2888EBA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.24";
        hash = "sha512-jaMi5T81NBZG/aBzhXSx9dAlIKLxxJ9zCIJ3c49l3KbFbybDX7/LfH7h0OIg6ntBWkXotQoFGcUOFXa05kFyRw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.24";
        hash = "sha512-hPhigpK6MZ6/bT2RgWQILUNL+aSEs3ikJumQQ4M5Jhcnc6r2x3XYzHzLPW06KU4aryHmVy5+6j6M/sm5wVtXWQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.24";
        hash = "sha512-gR/1n3LfHFAQrFom/k53+iquJ/ZDYD529PkqQ3bOkA+zyHWX6Fdr/VMk0j6DDh7ausZvn9ydVzfIZgJgGe+ybQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.24";
        hash = "sha512-qmngHPQYHLx6xbjYOxeexZijGQlNmfDqX0jLd0WjlL7lyK5q17bvQckVC2BjDhaXKfmUXdlQhPVpHy89V82H7A==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.24";
        hash = "sha512-5A6S5/YLp0lhDDRanye2XR5prLPb7iopuiKj6rOeOYg+eR6f8ujcKXXk7z7QfZvl7C2KGl65rymo/7CwseGj3A==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.24";
        hash = "sha512-whjjq2shpir90Q+wwOiCiL+m5NOahPHDs+a0XhmssnV45upcTmAuPccvfO4GTV+LzZZ8vx+6A7h7IAH6kJBqZg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.24";
        hash = "sha512-fhb/MkOr2RJDHtxl9xKGZkkrO1gFbZSRUA4ipbqgVTjcPQW+IASW0fHWx4Zvazy8G4UmPAEv2letBUFp0nooWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.24";
        hash = "sha512-eu0X7iN/U7rLNz4QbhhYCHNtsJFMLCEYjj2vHcabrvrzKGCzVpyMPlHvWfAYGRlaXwHfPA9lnG86xJ0kZMinUw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.24";
        hash = "sha512-Hst8AqJF/F2Nojw30O69YXknS16RwZrpXM9SrsqTlnvdJ03WZnmbtYItUCz8BjpsHjdRKleSUjGrFBgviOUMQw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.24";
        hash = "sha512-H9AYUeamFxbWPbQaBRcKd3CKEXtn567ObzwBYAw62cW/auSn78VdqcmFNeGjAwSBiSPX2FkkRTrU5bE9swVZTQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.24";
        hash = "sha512-dIzYTbBt6CLWqSueQw7HvLpJBnbR5Ed47DA9UUAqh9vgjfJTjdPyggYTF22LMO60M0yP8HxvW+XwTNGv43lyGQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.24";
        hash = "sha512-05RZrc3zVFRIgi3Cw+V48upDk4WgHG1DutKl1dWZcm+ZCnS6rrEoC3QQmc1xk/P94/5z9uhKO9wPR/3jRLm/vQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.24";
        hash = "sha512-DBWl+uM9sFhd7+PG9cAq6+HkGs7A57tWAoiH29XrYsttKB3uhBdGcSLgyRsn9raspdAJXAif+1V0gK0UU8DVjw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.24";
        hash = "sha512-mAgwLFJkH+MIy+eKFj+wAYyM7GfPzAyKHnJhNGMoNvCabr27jXb29rRHhQPHnEeuhyf5hO0gN9ch402ddT1tXQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.24";
        hash = "sha512-RnHiYW3X3MbZbe1ArFSI19gT7On+a2JWFhgRtxeDP/PcV0fv08YFowXCLBThRA27cXVQzX1jFgB2rxSHbofiKg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.24";
        hash = "sha512-FkGu9zI5Bq9ucv0UhpzOunJcrtxdujmR8YQQ8MM5nH/OnP0Yersrtt/BaDNcN45miOCXPhdM4+nM4g31XQth5A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.24";
        hash = "sha512-bxmHBY7pAJmr7rIOrlcmjuHuiCuFEWQHfeT8KyAH0MnpJn0KBKml6+kNBNHfXgv/AUGFCy0m40aco4w3znuy7Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.24";
        hash = "sha512-ebcviRjodT635cs0zZX5xB18hm3HhTuWAfbhWbtuTe7BxT7EWYPlVR7cSjNP7VjctsdrsPRLnBy7IURMuRKRXA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.24";
        hash = "sha512-AuyI8sz9s40YhlkoIPz7BXa3mcLkStK1MJBZ3YuQ333F42nTW2pvMhIol08qhFLBq3ruvPFDPx6+sK5QYCwY4Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.24";
        hash = "sha512-ThIBQbQEgp2W5fDq2bOdFUHiLdthbvabHUI65SLe+HgvAqh5hHyRZltM22zy24PzYZpw3BSoONg/qsq3duN5TQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.24";
        hash = "sha512-HaLbfBmoIebAdANIIHK4EUkZ9w64QTWxeoBS5sEGCKs5rU/XB6dSGLEx9Dl8YMcWoRnEPcu7/cs+FeOzuTkAEw==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.24";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.24";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.24/aspnetcore-runtime-8.0.24-linux-arm.tar.gz";
        hash = "sha512-dgmc08sc/PivNsVro7jIahabueyCWcEQdEG6v+yN0SMPjVBeARPlQuKZgqU7owahC5pqsm6+hI6TqasC+IBsBQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.24/aspnetcore-runtime-8.0.24-linux-arm64.tar.gz";
        hash = "sha512-4mlJGVPFUuz9MeYgBS7shOYLKNo5zgbC1kwyLamhZKbIlqHam/ll33jm397Gq55CrVw2ssZB1uoFpSQ5MKY5HA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.24/aspnetcore-runtime-8.0.24-linux-x64.tar.gz";
        hash = "sha512-mlyyWZBkn8HHVnXpTi5Gmd/Fl5qZou7Da6uyQMpSePGsJVLs/sFoNESaw9VIKg/TA6xLpTykdJ+r+ysBlLpGNQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.24/aspnetcore-runtime-8.0.24-linux-musl-arm.tar.gz";
        hash = "sha512-0DIwA8FxYwAf5dnXgleybElZdtJWFjJvRAfB3UnblBUhe9J68eDw7ZbRjWKl+wybBeqgQCjKh97B+57mlEEGrA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.24/aspnetcore-runtime-8.0.24-linux-musl-arm64.tar.gz";
        hash = "sha512-AzOlG+RJQfD6p4vOCj5uNX4XE6b6S8BGHDsRNdP483HN9AGzVAAnp0KLNMIv5jamHS6E48fGZt8STciePwh6DQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.24/aspnetcore-runtime-8.0.24-linux-musl-x64.tar.gz";
        hash = "sha512-8upqGBLzje3Drgu3u5h4Jv7N1sJQBrcwlFuL6MoFQX1R1b7GflgFjDccq4RzjOY25koOXGcu9aXCvErmoBOq1w==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.24/aspnetcore-runtime-8.0.24-osx-arm64.tar.gz";
        hash = "sha512-y8fSlSvIUfU+IzjWS/9MNj+nJqwqDKJwGuvxTN+JW+Z1kgGYnipTd+TYyRueUKx9HXc+aI90eqSYI2GmxVh6vw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.24/aspnetcore-runtime-8.0.24-osx-x64.tar.gz";
        hash = "sha512-8xFOGfcH4iNpS/VOng09zsMqQZJVjyBcfcxqLxiGRDgak6nA8R9+xiEA1tMNTHV8R2BEOqDMn+Y4zF3pdm48ng==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.24";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.24/dotnet-runtime-8.0.24-linux-arm.tar.gz";
        hash = "sha512-1yJ31JLcbot/m7T2w3t0svin+uc4pXsVKYhUzQkaEkhUUtWFA0U7sYBINU9Pdv2VE4eo929jut9kOSRbtpwzjA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.24/dotnet-runtime-8.0.24-linux-arm64.tar.gz";
        hash = "sha512-PpY1i0P7KyxWH0XpOZhvkwFfzIyuj3lIxHYTnGE8Q0Zzp/xg7DsE8Tti+rPntb9ZKY+87FQzuGBKP6/FPiEviQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.24/dotnet-runtime-8.0.24-linux-x64.tar.gz";
        hash = "sha512-odzqQJ/Cl2ddbDCsO69dZ+k82JyS/ZkwURVlLEnkSMVu75WbYOhw3ms8DS2gvT9Cr+CJtfXLOwaITTsilDJpEg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.24/dotnet-runtime-8.0.24-linux-musl-arm.tar.gz";
        hash = "sha512-qgZckobOya+yUihL5ptiUEVqMu0+avm3v7qs14inLVPE/IPFbXcUlu8m37rZS7L4HLMIZvFXMoIRIUgcKjTkjQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.24/dotnet-runtime-8.0.24-linux-musl-arm64.tar.gz";
        hash = "sha512-N+SGFc8E2syWKUfB4WXAomugcamlpfss8VGzcAFhj/hYNei2axGve8+ZvNYLsOoEkCrtLkT4X90KSZJIRnG5UQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.24/dotnet-runtime-8.0.24-linux-musl-x64.tar.gz";
        hash = "sha512-c5A0Zmnrt0h11mXdjLaYH3mq9uWXAljfJw0MpYc+wkgGWdlM5mTTnCtB0p8YycuqH6ndEmvrs0ZvdcPKAgoD+Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.24/dotnet-runtime-8.0.24-osx-arm64.tar.gz";
        hash = "sha512-t9mUKdV9qbaG0IJAzV029JazU/GhqHEeMe0u3w+7IYyfaAdnOr4GDTl19Vbk11O4Zi3NWrqZARHWmqWvUkUPsw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.24/dotnet-runtime-8.0.24-osx-x64.tar.gz";
        hash = "sha512-1HCXfU/Uls7B37e4HmjHkGOL8iweFbn6lru03oVB1tFI6sGv/GGXcJVJKyMBwa1ZkLUJK16J8ycTzMmJlfmvvw==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.418";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.418/dotnet-sdk-8.0.418-linux-arm.tar.gz";
        hash = "sha512-FGatb0q63rM9V/8+Bi25Cxk33XmPpoacAT5/1kJvJvIR8OciL3Jwf84s3yJs1peiZUtnVhz4xU7dBaoZRQevQw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.418/dotnet-sdk-8.0.418-linux-arm64.tar.gz";
        hash = "sha512-kZPJp3pe7frCSXQWDpstlYZeiMjE8HQQQtLrtLwzF780HsuXSsba2RwQ163uIttxezXT/vaG9arWf0r/RFdAMw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.418/dotnet-sdk-8.0.418-linux-x64.tar.gz";
        hash = "sha512-+9n8nwvKc/dx55wS1yGhjal7ojxDeUuUGxEMyqwPzRYVbJlqW5z8BlASBgF5HykJ6T7LJo9ofHuCiJk0x2bCuQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.418/dotnet-sdk-8.0.418-linux-musl-arm.tar.gz";
        hash = "sha512-P5T4uFEbazsZYOqvqZaqh5ElDJTVibIk/VrKnWLlXRYfC9kZzDKKjQyuu5NOmTi8ltIari9V+ViX5XJ4FWFOig==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.418/dotnet-sdk-8.0.418-linux-musl-arm64.tar.gz";
        hash = "sha512-s6/mfsY1daTK8yk7ftMCnKJMVoB7jVSpGIHp0LB1J60sAWF2Dz4lUZANUlWDA9tbmWo/S5E/CtzDcm8RQv9qJg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.418/dotnet-sdk-8.0.418-linux-musl-x64.tar.gz";
        hash = "sha512-3Q3wSEEpGQRVYasOVg2MV17CVHcp24SwMGEV1aquo1X0kdAkyeP152QsYjfEshQ50nnfp9y73Jo5A3zxxURasQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.418/dotnet-sdk-8.0.418-osx-arm64.tar.gz";
        hash = "sha512-EdatsgRYbosmN0reHBThEqUA1EGX0+lpcMp8Pgv263tA1FP7CxIUDtzU5wKXviQAYgMfHsdA1WX/XolSkvHJoA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.418/dotnet-sdk-8.0.418-osx-x64.tar.gz";
        hash = "sha512-qpN6kLWNHDbOmxWEu7UjdMPphGe71I0bqqXNDzAJO/u86lYbP7goeKDdFKsg8HCK5ZGXS+/FDmKrTdkCzwAoYA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.124";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.124/dotnet-sdk-8.0.124-linux-arm.tar.gz";
        hash = "sha512-75evZRMuUqzh80PMXvyVikEWvr4Yq8Of4kgeCWYzq2WyGpnDYtVb2Yd+/78jl8FBdOp8s0SLe+QxP2gZjw6K0g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.124/dotnet-sdk-8.0.124-linux-arm64.tar.gz";
        hash = "sha512-0mPHrn6ULpijcbofJDK+c5IgRlSAyBqftLS0rY5zy1WKaSOZBkd/547DnuH8Ge85wgYL8Y2T5fxqgu23KYbZYQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.124/dotnet-sdk-8.0.124-linux-x64.tar.gz";
        hash = "sha512-7yNAyKT+gI0TnnC8dXnpRjN9FJaJRNQSd4ePb/rZ8PCsSleuwzqIMzQ3JmAscdqzu28PVcTQkfg0ELAovdMfgw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.124/dotnet-sdk-8.0.124-linux-musl-arm.tar.gz";
        hash = "sha512-rmV78lQ1OPpq51uMwDJ/7QSpCcEb+Zgb9DR1s+X5Pk+ROFTKfuQpIYznjWQ9Vb4X1KIuAcjP6ZCHrHa0YfEGuA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.124/dotnet-sdk-8.0.124-linux-musl-arm64.tar.gz";
        hash = "sha512-Ih6j6tkybkzYy2tGsMP/ygtCMSNFBVB30FDFmmvpKpu/cc2Q/MtR/2d/Lz8TLXiLYv192/fbsFZqxN2r2cc1xQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.124/dotnet-sdk-8.0.124-linux-musl-x64.tar.gz";
        hash = "sha512-GQtgf/WD5KE73CuAZLPcXng3WRpUkg8lAOojC9oD2RRfvCNntPLK6F4OVOeTXVdCQOYJJ1CXESiD7/0FWBBxgA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.124/dotnet-sdk-8.0.124-osx-arm64.tar.gz";
        hash = "sha512-8eZuSA+7nnuVzQRE4s74S+UTLaWVHRXOYVhs7q54RmDDFzkupmHcG8LAfPrtwMwnxOTRb0zvu6Hv1AUHxqKGOQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.124/dotnet-sdk-8.0.124-osx-x64.tar.gz";
        hash = "sha512-PwU6FL8Yzs+gKctmREH+XbabfPjbpK2yVWPt/ISipr0o3oUQbaVlz0xk3ubGfv6AyK7rMNYe80iXQM7OtoArFg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
