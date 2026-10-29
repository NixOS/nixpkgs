var output = thisProcess.argv[0];
var definition, score;

try {
    // Resolve symbols at runtime: an undefined class literal prevents the entire
    // script (including its error handler and exit) from being compiled.
    [\MembraneHexagon, \MdaPiano].do { |name|
        if(name.asClass.isNil) {
            Error("Missing SC3 class: " ++ name).throw;
        };
    };

    definition = SynthDef(\sc3PluginsTest, {
        // Give each UGen its own output channel so neither can mask a failure.
        Out.ar(0, \MembraneHexagon.asClass.ar(Impulse.ar(0)));
        Out.ar(1, \MdaPiano.asClass.ar.sum);
    });
    score = Score([
        [0, [\d_recv, definition.asBytes]],
        [0, [\s_new, definition.name, 1000, 0, 0]],
        [1, [\n_free, 1000]]
    ]);

    score.recordNRT(
        oscFilePath: output +/+ "score.osc",
        outputFilePath: output +/+ "sc3.wav",
        headerFormat: "WAV",
        sampleFormat: "float",
        options: ServerOptions.new.numInputBusChannels_(0).numOutputBusChannels_(2),
        action: { |exitCode|
            var file, samples;
            try {
                if(exitCode != 0) { Error("scsynth exited with " ++ exitCode).throw };
                file = SoundFile.openRead(output +/+ "sc3.wav");
                if(file.isNil) { Error("No rendered audio").throw };
                if(file.numChannels != 2) { Error("Expected two audio channels").throw };
                if(file.numFrames < 44100) { Error("Incomplete rendered audio").throw };
                samples = FloatArray.newClear(file.numFrames * file.numChannels);
                file.readData(samples);
                file.close;
                samples.clump(2).flop.do { |channel|
                    if(channel.any { |sample| sample.isNaN or: { sample.abs == inf } }) {
                        Error("Invalid SC3 UGen output").throw;
                    };
                    if(channel.abs.maxItem <= 0.00001) { Error("Silent SC3 UGen output").throw };
                };
                "SC3 plugins rendered successfully".postln;
                0.exit;
            } { |error|
                error.reportError;
                1.exit;
            };
        }
    );
} { |error|
    error.reportError;
    1.exit;
};
